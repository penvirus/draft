#include <usock.h>
#include <stdio.h>
#include <string.h>
#include <err.h>
#include <unistd.h>
#include "shukp.h"

int main(int argc, char ** argv, char ** envp) {
	int client_fd;
	char * arguments[BUF_MAX];

	if(argc != 2) errx(0, "%s", SHUKP_206_INSUFFICIENT_ARGUMENT);

	/* parse SHUKP_* environment variables */ {
		int i, k;

		for(k=0; k<BUF_MAX; ++k)
			arguments[k] = NULL;

		for(i=0, k=0; envp[i]!=NULL && k<BUF_MAX; ++i) {
			char line[BUF_MAX];
			char * p;

			memset(line, 0, BUF_MAX);
			strncpy(line, envp[i], BUF_MAX - 1);

			p = strstr(line, SHUKP_ENVIRONMENT_VARIABLE_PREFIX);
			if(p == NULL || p != line) continue;

			arguments[k++] = envp[i];
		}
	}

	client_fd = get_blocking_usock_client("/tmp/form.sock");
	if(client_fd == -1) errx(0, "%s", SHUKP_501_INTERNAL_ERROR);

	{
		char buf[BIGBUF_MAX];
		int i, n;

		memset(buf, 0, BIGBUF_MAX);
		strncpy(buf, argv[1], BIGBUF_MAX -1);
		for(i=0; i<BUF_MAX && arguments[i]!=NULL; ++i) {
			strncpy(buf + strlen(buf), " ", BIGBUF_MAX - 1 - strlen(buf));
			strncpy(buf + strlen(buf), arguments[i], BIGBUF_MAX - 1 - strlen(buf));
		}

		for(i=0; i<strlen(buf); ) {
			n = write(client_fd, buf + i, strlen(buf) - i);
			if(n == -1) err(0, "%s", SHUKP_501_INTERNAL_ERROR);
			else if(n == 0) break;
			else i += n;
		}

		while(1) {
			memset(buf, 0, BIGBUF_MAX);
			n = read(client_fd, buf, BIGBUF_MAX - 1);
			if(n == -1) err(0, SHUKP_501_INTERNAL_ERROR);
			else if(n == 0) break;
			else printf("%s", buf);
		}

		close(client_fd);
	}

	return 0;
}

