#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include "server_error.h"
#include "common.h"
#include "response.h"

extern FILE * log_fp;

static void _se_append_error_string(char * msg, int len) {
	strncat(msg, ": ", len - strlen(msg));
	strncat(msg, strerror(errno), len - strlen(msg));
}
void se_error(char * fmt, ...) {
	va_list ap;
	char error_msg[BUFFER_LEN_MAX];

	memset(error_msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(error_msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_se_append_error_string(error_msg, BUFFER_LEN_MAX - 1);
	send_internal_error_response(error_msg);

	if(log_fp != NULL) fprintf(log_fp, "se_error: %s\n", error_msg);

	exit(1);
}
void sex_error(char * fmt, ...) {
	va_list ap;
	char error_msg[BUFFER_LEN_MAX];

	va_start(ap, fmt);
	vsnprintf(error_msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	send_internal_error_response(error_msg);

	if(log_fp != NULL) fprintf(log_fp, "sex_error: %s\n", error_msg);

	exit(1);
}

static void _send_response(char * fmt, ...) {
	char buf[BUFFER_LEN_MAX];
	va_list ap;

	va_start(ap, fmt);
	vsnprintf(buf, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	printf("%s\n", buf);

	if(log_fp != NULL) fprintf(log_fp, "_send_response: send [%s]\n", buf);
}
/* 1XX - Continue */
void send_continue_response() {
	_send_response("%d %s", RESPONSE_CODE_CONTINUE, RESPONSE_MESSAGE_CONTINUE);
}
void send_sending_response(int length) {
	_send_response("%d %s <%d>", RESPONSE_CODE_SENDING, RESPONSE_MESSAGE_SENDING, length);
}
/* 2XX - Positive */
void send_ok_response() {
	_send_response("%d %s", RESPONSE_CODE_OK, RESPONSE_MESSAGE_OK);
}
void send_warning_response(const char * warning_msg) {
	_send_response("%d %s <%s>", RESPONSE_CODE_WARNING, RESPONSE_MESSAGE_WARNING, warning_msg);
}
/* 4XX - Negative */
void send_request_rejected_response() {
	_send_response("%d %s", RESPONSE_CODE_REQUEST_REJECTED, RESPONSE_MESSAGE_REQUEST_REJECTED);
}
void send_bad_request_response() {
	_send_response("%d %s", RESPONSE_CODE_BAD_REQUEST, RESPONSE_MESSAGE_BAD_REQUEST);
}
void send_insufficient_metadata_response() {
	_send_response("%d %s", RESPONSE_CODE_INSUFFICIENT_METADATA, RESPONSE_MESSAGE_INSUFFICIENT_METADATA);
}
/* 5XX - Internal Error */
void send_internal_error_response(const char * error_msg) {
	_send_response("%d %s <%s>", RESPONSE_CODE_INTERNAL_ERROR, RESPONSE_MESSAGE_INTERNAL_ERROR, error_msg);
}


