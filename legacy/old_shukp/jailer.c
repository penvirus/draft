#include <usock.h>
#include <stdio.h>
#include <err.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <string.h>
#include <stdlib.h>
#include  "shukp.h"

int main(int argc, char ** argv) {
	int server_fd;

	server_fd = get_blocking_usock_server("/home/shukp/tmp/form.sock");
	if(server_fd == -1) errx(1, "%s", SHUKP_501_INTERNAL_ERROR);

	if(chmod("/home/shukp/tmp/form.sock", S_IRUSR | 0777) == -1) err(1, "%s", SHUKP_501_INTERNAL_ERROR);

	while(1) {
		int client_fd;
		pid_t pid;

		client_fd = accept(server_fd, NULL, NULL);
		if(client_fd == -1) err(1, "%s", SHUKP_501_INTERNAL_ERROR);

		pid = fork();
		if(pid == -1) {
			err(1, "%s", SHUKP_501_INTERNAL_ERROR);
		} else if(pid > 0) {
			close(client_fd);
		} else {
			if(close(server_fd) == -1) err(1, "%s", SHUKP_501_INTERNAL_ERROR);
			if(close(0) == -1) err(1, "%s", SHUKP_501_INTERNAL_ERROR);
			if(close(1) == -1) err(1, "%s", SHUKP_501_INTERNAL_ERROR);
			if(close(2) == -1) err(1, "%s", SHUKP_501_INTERNAL_ERROR);
			if(dup(client_fd) == -1) err(1, "%s", SHUKP_501_INTERNAL_ERROR);
			if(dup(client_fd) == -1) err(1, "%s", SHUKP_501_INTERNAL_ERROR);
			if(dup(client_fd) == -1) err(1, "%s", SHUKP_501_INTERNAL_ERROR);
			if(close(client_fd) == -1) err(1, "%s", SHUKP_501_INTERNAL_ERROR);

			{
				int n;
				char buf[BIGBUF_MAX];
				char sbuf[BUF_MAX];
				char * command;
				char * layer1_pointer, * layer1_strtok;

				memset(buf, 0, BIGBUF_MAX);
				n = read(0, buf, BIGBUF_MAX - 1);
				if(n == -1) err(1, "%s", SHUKP_501_INTERNAL_ERROR);
				else if(n == 0) exit(0);

				memset(sbuf, 0, BUF_MAX);
				layer1_pointer = strtok_r(buf, " ", &layer1_strtok);
				if(layer1_pointer == NULL) err(1, "%s", SHUKP_501_INTERNAL_ERROR);
				command = layer1_pointer;

				while((layer1_pointer = strtok_r(NULL, " ", &layer1_strtok)) != NULL) {
					char * key, * value, * layer2_strtok;

					key = strtok_r(layer1_pointer, "=", &layer2_strtok);
					if(key == NULL) err(1, "%s", SHUKP_501_INTERNAL_ERROR);
					value = strtok_r(NULL, "=", &layer2_strtok);
					if(value == NULL) err(1, "%s", SHUKP_501_INTERNAL_ERROR);

					if(setenv(key, value, 1) == -1) err(1, "%s", SHUKP_501_INTERNAL_ERROR);
				}

				{
					char r_command[BUF_MAX];

					memset(r_command, 0, BUF_MAX);
					sprintf(r_command, "./%s.sh", command);
					execlp(r_command, r_command, NULL);
				}

				/* here should never happen, because we already call exec */
				err(1, "%s", SHUKP_501_INTERNAL_ERROR);
			}
		}
	}

	return 0;
}

