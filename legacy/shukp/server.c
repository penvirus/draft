#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <stdlib.h>
#include <stdarg.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include "common.h"
#include "server.h"
#include "response.h"
#include "server_error.h"
#include "metadata.h"
#include "io.h"

FILE * log_fp;
char working_directory[SBUFFER_LEN_MAX];
int keep_log;

struct request {
	char command[SBUFFER_LEN_MAX];
	char data[SBUFFER_LEN_MAX];
};
struct request get_request() {
	struct request request;
	char buf[BUFFER_LEN_MAX];

	memset(&request, 0, sizeof(struct request));
	if(fgets(buf, BUFFER_LEN_MAX, stdin) == NULL) sex_error("fgets");
	sscanf(buf, "%[^: \t\n]%*[^<]<%[^>]\n", request.command, request.data);

	if(log_fp != NULL) fprintf(log_fp, "get_request: receive: raw=[%s", buf);
	if(log_fp != NULL) fprintf(log_fp, "get_request: receive: command=[%s] data=[%s]\n", request.command, request.data);

	return request;
}

void create_working_directory() {
	snprintf(working_directory, SBUFFER_LEN_MAX, "%s/%s", RAM_DIR_PATH, PROJECT_NAME);
	if(create_directory(working_directory) == -1) se_error("create_directory");

	snprintf(working_directory, SBUFFER_LEN_MAX, "%s/%s/server-%d", RAM_DIR_PATH, PROJECT_NAME, getpid());
	if(create_directory(working_directory) == -1) se_error("create_directory");
}

void authentication() {
	struct request request;

AUTHENTICATION_VERSION_COMMAND:
	if(log_fp != NULL) fprintf(log_fp, "authentication: version command\n");

	request = get_request();
	if(strcasecmp(request.command, VERSION_COMMAND) == 0) {
		/* compare version number */
		float c_version, s_version;

		s_version = strtof(VERSION, NULL);
		c_version = strtof(request.data, NULL);

		if(c_version < s_version) {
			send_request_rejected_response();
			goto AUTHENTICATION_VERSION_COMMAND;
		} else if(c_version > s_version) {
			send_warning_response("newer version client");
		} else {
			send_ok_response();
		}
		goto AUTHENTICATION_API_KEY_COMMAND;
	} else if(strcasecmp(request.command, UPDATE_COMMAND) == 0) {
		struct stat statbuf;
		int ifd, fsize, ret;

		memset(&statbuf, 0, sizeof(struct stat));
		if(stat(CLIENT_INSTALL_PATH, &statbuf) == -1) se_error("stat");

		fsize = statbuf.st_size;
		send_sending_response(fsize);

		if((ifd = open(CLIENT_INSTALL_PATH, O_RDONLY)) == -1) se_error("open");

		if(log_fp != NULL) fprintf(log_fp, "authentication: io: ifd=[%d] ofd=[1] length=[%d]\n", ifd, fsize);

		if((ret = io(ifd, 1, fsize)) == -1) se_error("io");
		else if(ret == 0) sex_error("io");
		close(ifd);

		goto AUTHENTICATION_VERSION_COMMAND;
	} else {
		send_bad_request_response();
		goto AUTHENTICATION_VERSION_COMMAND;
	}

AUTHENTICATION_API_KEY_COMMAND:
	if(log_fp != NULL) fprintf(log_fp, "authentication: api_key command\n");

	request = get_request();
	if(strcasecmp(request.command, API_KEY_COMMAND) != 0) {
		send_bad_request_response();
		goto AUTHENTICATION_API_KEY_COMMAND;
	}

	if(strcasecmp(request.data, API_KEY) != 0) {
		send_request_rejected_response();
		goto AUTHENTICATION_API_KEY_COMMAND;
	} else {
		send_ok_response();
	}
}

void receive_commands() {
	char command[BUFFER_LEN_MAX];
	struct request request;

	if(log_fp != NULL) fprintf(log_fp, "receive_commands: start\n");

RECEIVE_COMMANDS:
	request = get_request();

	/* internal commands */
	if(strcasecmp(request.command, RESET_COMMAND) == 0) {
		struct metadata * iterator;

		for(iterator=get_metadata(); iterator!=NULL; iterator=iterator->next)
			if(unsetenv(iterator->key) == -1)
				send_internal_error_response("unsetenv");
		free_metadata();
		send_ok_response();
		goto RECEIVE_COMMANDS;
	}
	if(strcasecmp(request.command, QUIT_COMMAND) == 0) {
		send_ok_response();
		exit(0);
	}

	/* inputfile meta-data*/
	if(strcasecmp(request.command, DATA_NAME_COMMAND) == 0) {
		int fsize, ofd, ret;
		char dataname[SBUFFER_LEN_MAX];
		char filepath[SBUFFER_LEN_MAX];

		send_continue_response();

		snprintf(dataname, SBUFFER_LEN_MAX, "%s", request.data);
		snprintf(filepath, SBUFFER_LEN_MAX, "%s/%s", working_directory, request.data);

		request = get_request();
		if(strcasecmp(request.command, DATA_LENGTH_COMMAND) != 0) {
			send_bad_request_response();
			goto RECEIVE_COMMANDS;
		}

		fsize = strtol(request.data, NULL, 10);
		if((ofd = open(filepath, O_CREAT | O_TRUNC | O_WRONLY, 0755)) == -1) se_error("open");

		if(log_fp != NULL) fprintf(log_fp, "receive_commands: io: ifd=[1] ofd=[%d] length=[%d]\n", ofd, fsize);

		if((ret = io(0, ofd, fsize)) == -1) se_error("io");
		else if(ret == 0) sex_error("connection broken");
		close(ofd);

		snprintf(command, BUFFER_LEN_MAX, "%s=%s", dataname, filepath);
		if(add_inputfile_metadata_from_string(command) == -1) sex_error("add_inputfile_metadata_from_string");

		send_ok_response();
		goto RECEIVE_COMMANDS;
	}

	/* external commands */
	if(request.data[0] == 0) {
		struct metadata * iterator;
		char sbuf[SBUFFER_LEN_MAX];

		for(iterator=get_metadata(); iterator!=NULL; iterator=iterator->next)
			if(setenv(iterator->key, iterator->value, 1) == -1)
				se_error("setenv");

		snprintf(sbuf, SBUFFER_LEN_MAX, "%s/%s", EXTERNAL_COMMAND_PATH, request.command);
		if(access(sbuf, R_OK | X_OK) == -1) {
			if(errno == ENOENT || errno == EACCES) send_bad_request_response();
			else send_internal_error_response("access");
		} else {
			if(system(sbuf) == -1) send_internal_error_response("system");
		}
		goto RECEIVE_COMMANDS;
	}

	/* meta-data */
	{
		snprintf(command, BUFFER_LEN_MAX, "%s=%s", request.command, request.data);
		if(add_metadata_from_string(command) == -1) send_internal_error_response("add_metadata_from_string");
		else send_ok_response();
		goto RECEIVE_COMMANDS;
	}

	goto RECEIVE_COMMANDS;
}

void delete_working_directory() {
	char sbuf[SBUFFER_LEN_MAX];

	snprintf(sbuf, SBUFFER_LEN_MAX, "rm -rf %s", working_directory);
	system(sbuf);
}

int main(int argc, char **argv) {
	char ch;

	log_fp = NULL;
	keep_log = 0;
	while((ch = getopt(argc, argv, "l:K")) != -1)
		switch(ch) {
		case 'l':
			if((log_fp = fopen(optarg, "a")) == NULL) se_error("fopen");
			if(setvbuf(log_fp, NULL, _IONBF, 0) == -1) se_error("setvbuf");
			break;
		case 'K':
			keep_log = 1;
			break;
		}

	create_working_directory();

	if(!keep_log) {
		if(atexit(delete_working_directory) != 0) sex_error("atexit");
	}

	if(setvbuf(stdin, NULL, _IONBF, 0) == -1) se_error("setvbuf");
	if(setvbuf(stdout, NULL, _IONBF, 0) == -1) se_error("setvbuf");

	authentication();
	receive_commands();

	return 0;
}

