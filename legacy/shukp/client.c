#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>
#include "common.h"
#include "metadata.h"
#include "client_error.h"
#include "response.h"
#include "io.h"

static struct option options[] = {
	{"apikey",	required_argument, NULL, 'a'},
	{"server",	required_argument, NULL, 's'},
	{"username",	required_argument, NULL, 'u'},
	{"keyfile",	required_argument, NULL, 'k'},
	{"port",	required_argument, NULL, 'p'},
	{"metadata",	required_argument, NULL, 'm'},
	{"metafile",	required_argument, NULL, 'M'},
	{"inputfile",	required_argument, NULL, 'i'},
	{"outputfile",	required_argument, NULL, 'o'},
	{"batchfile",	required_argument, NULL, 'b'},
	{"logfile",	required_argument, NULL, 'l'},
	{"timeout",	required_argument, NULL, 't'},
	{"keep-log",no_argument, NULL, 'K'},
	{"noautoupdate",no_argument, NULL, 'n'},
	{"interactive",	no_argument, NULL, 'I'},
	{"verbose",	no_argument, NULL, 'v'},
	{"version",	no_argument, NULL, 'V'},
	{"help",	no_argument, NULL, 'h'}
};

struct client_option {
	char apikey[SBUFFER_LEN_MAX];	/* -a */
	char server[SBUFFER_LEN_MAX];	/* -s */
	char username[SBUFFER_LEN_MAX];	/* -u */
	char keyfile[SBUFFER_LEN_MAX];	/* -k */
	unsigned int port;		/* -p */
	char outputfile[SBUFFER_LEN_MAX];/* -o */
	char batchfile[SBUFFER_LEN_MAX];/* -b */
	char logfile[SBUFFER_LEN_MAX];	/* -l */
	unsigned int timeout;		/* -t */
	int no_auto_update;	/* -n */
	int interactive_mode;	/* -I */
	int verbose_mode;		/* -v */
	int keep_log;	/* -K */

	char command[SBUFFER_LEN_MAX];
	char working_directory[SBUFFER_LEN_MAX];
	FILE * to_server;
	FILE * from_server;
} c_option;

void version() {
	printf("client %s\n", VERSION);
}

void help() {
	printf("Usage:\n");
	printf("\tclient \033[1;37m-a\033[m [API_KEY] \033[1;37m-s\033[m [SERVER] \033[1;37m-m\033[m USER_NAME=[USER_NAME] \033[1;37m-m\033[m MODULE_NAME=[MODULE_NAME] \033[1;37m-o\033[m [KEY_FILE] register\n");

	printf("\tclient \033[1;37m-a\033[m [API_KEY] \033[1;37m-s\033[m [SERVER] \033[1;37m-u\033[m [USER_NAME] \033[1;37m-k\033[m [IDENTITY_FILE] [\033[1;37m-m\033[m KEY=VALUE]... [OPTIONS]... COMMAND\n");
	printf("Options:\n");
	printf("\t\033[1;37m-a\033[m API_KEY | \033[1;37m--apikey\033[m=API_KEY\n");
	printf("\t\033[1;37m-s\033[m SERVER | \033[1;37m--server\033[m=SERVER\n");
	printf("\t\033[1;37m-u\033[m USER_NAME | \033[1;37m--username\033[m=USER_NAME\n");
	printf("\t\033[1;37m-k\033[m IDENTITY_FILE | \033[1;37m--keyfile\033[m=IDENTITY_FILE\n");
	printf("\t\033[1;37m-p\033[m PORT | \033[1;37m--port\033[m=PORT\n");
	printf("\t\033[1;37m-m\033[m KEY=VALUE | \033[1;37m--metadata\033[m=KEY=VALUE\n");
	printf("\t\033[1;37m-M\033[m META_FILE | \033[1;37m--metafile\033[m=META_FILE\n");
	printf("\t\033[1;37m-i\033[m [DATA_NAME=]INPUT_FILE | \033[1;37m--inputfile\033[m=[DATA_NAME=]INPUT_FILE\n");
	printf("\t\033[1;37m-o\033[m OUTPUT_FILE | \033[1;37m--outputfile\033[m=OUTPUT_FILE\n");
	printf("\t\033[1;37m-b\033[m BATCH_FILE | \033[1;37m--batchfile\033[m=BATCH_FILE\n");
	printf("\t\033[1;37m-l\033[m LOG_FILE | \033[1;37m--logfile\033[m=LOG_FILE\n");
	printf("\t\033[1;37m-t\033[m TIMEOUT | \033[1;37m--timeout\033[m=TIMEOUT\n");
	printf("\t\033[1;37m-n\033[m | \033[1;37m--noautoupdate\033[m\n");
	printf("\t\033[1;37m-I\033[m | \033[1;37m--interactive\033[m\n");
	printf("\t\033[1;37m-v\033[m | \033[1;37m--verbose\033[m\n");
	printf("\t\033[1;37m-V\033[m | \033[1;37m--version\033[m\n");
	printf("\t\033[1;37m-h\033[m | \033[1;37m--help\033[m\n");
}

void parse_arguments(int argc, char ** argv) {
	char ch;

	memset(&c_option, 0, sizeof(struct client_option));
	while((ch = getopt_long(argc, argv, "a:s:u:k:p:m:M:i:o:b:l:t:KnIvVh", options, NULL)) != -1)
		switch(ch) {
		case 'a': strncpy(c_option.apikey, optarg, SBUFFER_LEN_MAX - 1); break;
		case 's': strncpy(c_option.server, optarg, SBUFFER_LEN_MAX - 1); break;
		case 'u': strncpy(c_option.username, optarg, SBUFFER_LEN_MAX - 1); break;
		case 'k': strncpy(c_option.keyfile, optarg, SBUFFER_LEN_MAX - 1); break;
		case 'p':
		case 't':
			if(!validInteger(optarg)) cex_invalid_argument("%s", optarg);

			if(ch == 'p') c_option.port = strtol(optarg, NULL, 10);
			else c_option.timeout = strtol(optarg, NULL, 10);
			break;
		case 'm':
		case 'i':
			if(strchr(optarg, '=') == NULL) cex_invalid_argument("%s", optarg);

			if(ch == 'm') { if(add_metadata_from_string(optarg) == -1) ce_client_internal_error("add_metadata_from_string"); }
			else { if(add_inputfile_metadata_from_string(optarg) == -1) ce_client_internal_error("add_inputfile_metadata_from_string"); }
			break;
		case 'M':
			if(add_metadata_from_file(optarg) == -1) ce_client_internal_error("add_metadata_from_file");
			break;
		case 'o': strncpy(c_option.outputfile, optarg, SBUFFER_LEN_MAX - 1); break;
		case 'b': strncpy(c_option.batchfile, optarg, SBUFFER_LEN_MAX - 1); break;
		case 'l': strncpy(c_option.logfile, optarg, SBUFFER_LEN_MAX - 1); break;
		case 'K': c_option.keep_log = 1; break;
		case 'n': c_option.no_auto_update = 1; break;
		case 'I': c_option.interactive_mode= 1; break;
		case 'v': c_option.verbose_mode = 1; break;
		case 'V': version(); cex_normal_exit(NULL); break;
		case 'h': help(); cex_normal_exit(NULL); break;
		default: help(); cex_invalid_argument(NULL); break;
		}
	argc -= optind;
	argv += optind;

	if( c_option.apikey[0] == 0 || c_option.server[0] == 0 || argc != 1 ||
	    ((c_option.username[0] == 0 || c_option.keyfile[0] == 0) && (strcasecmp(argv[0], REGISTER_COMMAND) != 0)) ) {
		help();
		cex_invalid_argument("parse_arguments");
	}

	strncpy(c_option.command, argv[0], SBUFFER_LEN_MAX - 1);
}

void create_working_directory() {
	snprintf(c_option.working_directory, SBUFFER_LEN_MAX, "%s/%s", RAM_DIR_PATH, PROJECT_NAME);
	if(create_directory(c_option.working_directory) == -1) cex_client_internal_error("create_directory");

	snprintf(c_option.working_directory, SBUFFER_LEN_MAX, "%s/%s/client-%d", RAM_DIR_PATH, PROJECT_NAME, getpid());
	if(create_directory(c_option.working_directory) == -1) cex_client_internal_error("create_directory");
}

void establish_ssh_connection() {
	pid_t pid;
	int reserve[2], from_ssh[2], to_ssh[2];

	/* reserve 0 and 1 (if needed) */
	if(pipe(reserve) == -1) ce_client_internal_error("pipe");

	if(pipe(from_ssh) == -1) ce_client_internal_error("pipe");
	if(pipe(to_ssh) == -1) ce_client_internal_error("pipe");

	/* close reserve dummy fd */
	close(reserve[0]);
	close(reserve[1]);

	if((pid = fork()) == -1) {
		ce_client_internal_error("fork");
	} else if(pid == 0) {
		close(from_ssh[0]);
		close(to_ssh[1]);
		if(dup2(from_ssh[1], 1) == -1) ce_client_internal_error("dup2");
		if(dup2(to_ssh[0], 0) == -1) ce_client_internal_error("dup2");
		close(from_ssh[1]);
		close(to_ssh[0]);
		
		{
			char * args[64];
			int argi;
			char sbuf[SBUFFER_LEN_MAX];

			memset(args, 0, sizeof(char *) * 64);
			argi = 0;

			args[argi++] = "ssh";
			args[argi++] = "-4";
			args[argi++] = "-q";
			args[argi++] = "-x";
			args[argi++] = "-oForwardAgent=no";
			args[argi++] = "-oPermitLocalCommand=no";
			args[argi++] = "-oClearAllForwardings=yes";
			args[argi++] = "-oStrictHostKeyChecking=no";
			if(c_option.timeout != 0) {
				snprintf(sbuf, SBUFFER_LEN_MAX, "-oConnectTimeout=%d", c_option.timeout);
				if((args[argi++] = strdup(sbuf)) == NULL) ce_client_internal_error("strdup");
			} else {
				args[argi++] = "-oConnectTimeout=10";
			}

			snprintf(sbuf, SBUFFER_LEN_MAX, "-l%s", c_option.username);
			if((args[argi++] = strdup(sbuf)) == NULL) ce_client_internal_error("strdup");

			snprintf(sbuf, SBUFFER_LEN_MAX, "-i%s", c_option.keyfile);
			if((args[argi++] = strdup(sbuf)) == NULL) ce_client_internal_error("strdup");

			snprintf(sbuf, SBUFFER_LEN_MAX, "%s", c_option.server);
			if((args[argi++] = strdup(sbuf)) == NULL) ce_client_internal_error("strdup");

			args[argi++] = SERVER_INSTALL_PATH;

			if(c_option.verbose_mode) {
				snprintf(sbuf, SBUFFER_LEN_MAX, "-l%s", SERVER_LOG_PATH);
				if((args[argi++] = strdup(sbuf)) == NULL) ce_client_internal_error("strdup");
			}

			if(c_option.keep_log) {
				args[argi++] = "-K";
			}

			execvp(args[0], args);
			ce_client_internal_error("execvp");
		}
	} else {
		close(from_ssh[1]);
		close(to_ssh[0]);
		if((c_option.from_server = fdopen(from_ssh[0], "r")) == NULL) ce_client_internal_error("fdopen");
		if((c_option.to_server = fdopen(to_ssh[1], "w")) == NULL) ce_client_internal_error("fdopen");
		/* set to_ssh to UNBUFFER mode */
		if(setvbuf(c_option.to_server, NULL, _IONBF, 0) != 0) ce_client_internal_error("setvbuf");
	}
}

struct response {
	int code;
	char data[SBUFFER_LEN_MAX];
};
struct response get_response() {
	struct response response;
	char buf[BUFFER_LEN_MAX];

	memset(&response, 0, sizeof(struct response));
	if(fgets(buf, BUFFER_LEN_MAX, c_option.from_server) == NULL) cex_connection_timeout("fgets");
	sscanf(buf, "%d%*[^<]<%[^>]\n", &response.code, response.data);

	if(c_option.verbose_mode) printf("get_response: receive [%s", buf);

	return response;
}

void send_request(const char * request) {
	fprintf(c_option.to_server, "%s\n", request);

	if(c_option.verbose_mode) printf("send_request: send [%s]\n", request);
}

void auto_update() {
	struct response response;
	char command[BUFFER_LEN_MAX];

	snprintf(command, BUFFER_LEN_MAX, "%s", UPDATE_COMMAND);
	send_request(command);

	response = get_response();
	switch(response.code) {
	case RESPONSE_CODE_SENDING:
		{
			int ifd, ofd, fsize, ret;
			char sbuf[SBUFFER_LEN_MAX];

			if((ifd = fileno(c_option.from_server)) == -1) ce_client_internal_error("fileno");
			snprintf(sbuf, SBUFFER_LEN_MAX, "%s/client", c_option.working_directory);
			/* TODO: self update */
//			if(unlink("/bin/client") == -1) ce_client_internal_error("unlink");
//			snprintf(sbuf, SBUFFER_LEN_MAX, "/bin/client");
			if((ofd = open(sbuf, O_CREAT | O_TRUNC | O_WRONLY, 0755)) == -1) ce_client_internal_error("open");

			fsize = strtol(response.data, NULL, 10);

			if((ret = io(ifd, ofd, fsize)) == -1) ce_client_internal_error("io");
			else if(ret == 0) cex_connection_timeout("io");

			close(ifd);
			close(ofd);
		}
		break;
	case RESPONSE_CODE_INTERNAL_ERROR: cex_server_internal_error("%s", response.data); break;
	default: cex_client_internal_error(HERE_SHOULD_NEVER_HAPPEN); break;
	}
}

void authentication() {
	struct response response;
	char command[BUFFER_LEN_MAX];

	goto AUTHENTICATION_VERSION_COMMAND;

AUTHENTICATION_VERSION_COMMAND:
	if(c_option.verbose_mode) printf("authentication: version command\n");

	snprintf(command, BUFFER_LEN_MAX, "%s: <%s>", VERSION_COMMAND, VERSION);
	send_request(command);

	response = get_response();
	switch(response.code) {
	case RESPONSE_CODE_WARNING:
	case RESPONSE_CODE_OK: goto AUTHENTICATION_API_KEY_COMMAND; break;
	case RESPONSE_CODE_REQUEST_REJECTED:
		/* need update */
		if(c_option.verbose_mode) printf("require update\n");

		if(c_option.no_auto_update) cex_normal_exit("require update but noautoupdate is on");
		else auto_update();

		break;
	case RESPONSE_CODE_INTERNAL_ERROR: cex_server_internal_error("%s", response.data); break;
	default: cex_client_internal_error(HERE_SHOULD_NEVER_HAPPEN); break;
	}

AUTHENTICATION_API_KEY_COMMAND:
	if(c_option.verbose_mode) printf("authentication: api_key command\n");

	snprintf(command, BUFFER_LEN_MAX, "%s: <%s>", API_KEY_COMMAND, c_option.apikey);
	send_request(command);

	response = get_response();
	switch(response.code) {
	case RESPONSE_CODE_WARNING:
	case RESPONSE_CODE_OK: goto AUTHENTICATION_DONE; break;
	case RESPONSE_CODE_REQUEST_REJECTED: cex_invalid_argument("api key has been rejected"); break;
	case RESPONSE_CODE_INTERNAL_ERROR: cex_server_internal_error("%s", response.data); break;
	default: cex_client_internal_error(HERE_SHOULD_NEVER_HAPPEN); break;
	}

AUTHENTICATION_DONE:
	;
}

void send_commands() {
	char command[BUFFER_LEN_MAX];
	struct metadata * iterator;
	struct response response;

	/* send meta-data */
	for(iterator=get_metadata(); iterator!=NULL; iterator=iterator->next) {
		if(iterator->type == 'f') {
			snprintf(command, BUFFER_LEN_MAX, "%s: <%s>", DATA_NAME_COMMAND, iterator->key);
			send_request(command);

			response = get_response();
			switch(response.code) {
			case RESPONSE_CODE_CONTINUE: break;
			case RESPONSE_CODE_INTERNAL_ERROR: cex_server_internal_error("%s", response.data); break;
			default: cex_client_internal_error(HERE_SHOULD_NEVER_HAPPEN); break;
			}

			{
				struct stat statbuf;
				int fsize, ifd, ofd, ret;

				memset(&statbuf, 0, sizeof(struct stat));
				if(stat(iterator->value, &statbuf) == -1) ce_client_internal_error("stat");
				if((ifd = open(iterator->value, O_RDONLY)) == -1) ce_client_internal_error("open");
				if((ofd = fileno(c_option.to_server)) == -1) ce_client_internal_error("fileno");

				fsize = statbuf.st_size;

				snprintf(command, BUFFER_LEN_MAX, "%s: <%d>", DATA_LENGTH_COMMAND, fsize);
				send_request(command);

				if(c_option.verbose_mode) printf("send_commands: io: ifd=[%d] ofd=[%d] length=[%d]\n", ifd, ofd, fsize);

				if((ret = io(ifd, ofd, fsize)) == -1) ce_client_internal_error("io");
				else if(ret == 0) cex_connection_timeout("io");
				close(ifd);

				response = get_response();
				switch(response.code) {
				case RESPONSE_CODE_OK:
				case RESPONSE_CODE_WARNING: break;
				case RESPONSE_CODE_INTERNAL_ERROR: cex_server_internal_error("%s", response.data); break;
				default: cex_client_internal_error(HERE_SHOULD_NEVER_HAPPEN); break;
				}
			}
		} else {
			snprintf(command, BUFFER_LEN_MAX, "%s: <%s>", iterator->key, iterator->value);
			send_request(command);

			response = get_response();
			switch(response.code) {
			case RESPONSE_CODE_OK:
			case RESPONSE_CODE_WARNING: break;
			case RESPONSE_CODE_INTERNAL_ERROR: cex_server_internal_error("%s", response.data); break;
			default: cex_client_internal_error(HERE_SHOULD_NEVER_HAPPEN); break;
			}
		}
	}

	/* send execution command */
	{
		snprintf(command, BUFFER_LEN_MAX, "%s", c_option.command);
		send_request(command);

		response = get_response();
		switch(response.code) {
		case RESPONSE_CODE_SENDING:
			{
				int ifd, ofd, fsize, ret;

				fsize = strtol(response.data, NULL, 10);

				if((ifd = fileno(c_option.from_server)) == -1) ce_client_internal_error("fileno");

				if(c_option.outputfile[0] == 0) {
					if((ofd = open("default.out", O_CREAT | O_TRUNC | O_WRONLY, 0644)) == -1) ce_client_internal_error("open");
				} else {
					if((ofd = open(c_option.outputfile, O_CREAT | O_TRUNC | O_WRONLY, 0644)) == -1) ce_client_internal_error("open");
				}

				if(c_option.verbose_mode) printf("send_commands: io: ifd=[%d] ofd=[%d] length=[%d]\n", ifd, ofd, fsize);

				if((ret = io(ifd, ofd, fsize)) == -1) ce_client_internal_error("io");
				else if(ret == 0) ce_connection_timeout("io");
				close(ofd);
			}
			break;
		case RESPONSE_CODE_OK:
		case RESPONSE_CODE_WARNING: break;
		case RESPONSE_CODE_BAD_REQUEST: cex_client_internal_error("unknown command: %s", c_option.command); break;
		case RESPONSE_CODE_INSUFFICIENT_METADATA: cex_insufficient_argument(NULL); break;
		case RESPONSE_CODE_INTERNAL_ERROR: cex_server_internal_error("%s", response.data); break;
		default: cex_client_internal_error(HERE_SHOULD_NEVER_HAPPEN); break;
		}
	}

	/* QUIT */
	snprintf(command, BUFFER_LEN_MAX, "%s", QUIT_COMMAND);
	send_request(command);
}

void delete_working_directory() {
	char sbuf[SBUFFER_LEN_MAX];

	snprintf(sbuf, SBUFFER_LEN_MAX, "rm -rf %s", c_option.working_directory);
	system(sbuf);
}

int main(int argc, char ** argv) {
	parse_arguments(argc, argv);

	create_working_directory();

	if(!c_option.keep_log) {
		if(atexit(delete_working_directory) != 0) ce_client_internal_error("atexit");
	}

	/* set stdout to UNBUFFER mode */
	if(setvbuf(stdout, NULL, _IONBF, 0) != 0) ce_client_internal_error("setvbuf");
	
	if(strcasecmp(c_option.command, REGISTER_COMMAND) == 0) {
		FILE * identity_key;

		strncpy(c_option.username, COMMON_ACCOUNT_USERNAME, SBUFFER_LEN_MAX - 1);
		snprintf(c_option.keyfile, SBUFFER_LEN_MAX, "%s/%s", c_option.working_directory, "identity_key");
		if((identity_key = fopen(c_option.keyfile, "w")) == NULL) ce_client_internal_error("fopen");
		fprintf(identity_key, "%s", COMMON_ACCOUNT_PRIVATE_KEY);
		fclose(identity_key);
		if(chmod(c_option.keyfile, 0600) == -1) ce_client_internal_error("chmod");
	}

	establish_ssh_connection();
	authentication();
	send_commands();

	return CE_CODE_NORMAL_EXIT;
}

