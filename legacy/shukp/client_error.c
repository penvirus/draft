#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "common.h"
#include "client_error.h"

static void _ce_print(const char * category, const char * msg) {
	int type = 0;

	if(category != NULL) type |= 1;
	if(msg != NULL) type |= 2;

	switch(type) {
	case 1: printf("%s:\n", category); break;
	case 2: printf("%s\n", msg); break;
	case 3: printf("%s: %s\n", category, msg); break;
	}
}

static void _ce_append_error_string(char * dest, int len) {
	strncat(dest, ": ", len - strlen(dest));
	strncat(dest, strerror(errno), len - strlen(dest));
}



void ce_normal_exit(const char * fmt, ...) {
	char msg[BUFFER_LEN_MAX];
	va_list ap;

	memset(msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_ce_append_error_string(msg, BUFFER_LEN_MAX - 1);
	_ce_print(NULL, msg);

	exit(CE_CODE_NORMAL_EXIT);
}
void cex_normal_exit(const char * fmt, ...) {
	char msg[BUFFER_LEN_MAX];
	va_list ap;

	memset(msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_ce_print(NULL, msg);

	exit(CE_CODE_NORMAL_EXIT);
}


void ce_insufficient_argument(const char * fmt, ...) {
	char msg[BUFFER_LEN_MAX];
	va_list ap;

	memset(msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_ce_append_error_string(msg, BUFFER_LEN_MAX - 1);
	_ce_print(CE_CATEGORY_INSUFFICIENT_ARGUMENT, msg);

	exit(CE_CODE_INSUFFICIENT_ARGUMENT);
}
void cex_insufficient_argument(const char * fmt, ...) {
	char msg[BUFFER_LEN_MAX];
	va_list ap;

	memset(msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_ce_print(CE_CATEGORY_INSUFFICIENT_ARGUMENT, msg);

	exit(CE_CODE_INSUFFICIENT_ARGUMENT);
}


void ce_invalid_argument(const char * fmt, ...) {
	char msg[BUFFER_LEN_MAX];
	va_list ap;

	memset(msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_ce_append_error_string(msg, BUFFER_LEN_MAX - 1);
	_ce_print(CE_CATEGORY_INVALID_ARGUMENT, msg);

	exit(CE_CODE_INVALID_ARGUMENT);
}
void cex_invalid_argument(const char * fmt, ...) {
	char msg[BUFFER_LEN_MAX];
	va_list ap;

	memset(msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_ce_print(CE_CATEGORY_INVALID_ARGUMENT, msg);

	exit(CE_CODE_INVALID_ARGUMENT);
}


void ce_connection_timeout(const char * fmt, ...) {
	char msg[BUFFER_LEN_MAX];
	va_list ap;

	memset(msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_ce_append_error_string(msg, BUFFER_LEN_MAX - 1);
	_ce_print(CE_CATEGORY_CONNECTION_TIMEOUT, msg);

	exit(CE_CODE_CONNECTION_TIMEOUT);
}
void cex_connection_timeout(const char * fmt, ...) {
	char msg[BUFFER_LEN_MAX];
	va_list ap;

	memset(msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_ce_print(CE_CATEGORY_CONNECTION_TIMEOUT, msg);

	exit(CE_CODE_CONNECTION_TIMEOUT);
}


void ce_client_internal_error(const char * fmt, ...) {
	char msg[BUFFER_LEN_MAX];
	va_list ap;

	memset(msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_ce_append_error_string(msg, BUFFER_LEN_MAX - 1);
	_ce_print(CE_CATEGORY_CLIENT_INTERNAL_ERROR, msg);

	exit(CE_CODE_CLIENT_INTERNAL_ERROR);
}
void cex_client_internal_error(const char * fmt, ...) {
	char msg[BUFFER_LEN_MAX];
	va_list ap;

	memset(msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_ce_print(CE_CATEGORY_CLIENT_INTERNAL_ERROR, msg);

	exit(CE_CODE_CLIENT_INTERNAL_ERROR);
}


void ce_server_internal_error(const char * fmt, ...) {
	char msg[BUFFER_LEN_MAX];
	va_list ap;

	memset(msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_ce_append_error_string(msg, BUFFER_LEN_MAX - 1);
	_ce_print(CE_CATEGORY_SERVER_INTERNAL_ERROR, msg);

	exit(CE_CODE_SERVER_INTERNAL_ERROR);
}
void cex_server_internal_error(const char * fmt, ...) {
	char msg[BUFFER_LEN_MAX];
	va_list ap;

	memset(msg, 0, BUFFER_LEN_MAX);

	va_start(ap, fmt);
	vsnprintf(msg, BUFFER_LEN_MAX, fmt, ap);
	va_end(ap);

	_ce_print(CE_CATEGORY_SERVER_INTERNAL_ERROR, msg);

	exit(CE_CODE_SERVER_INTERNAL_ERROR);
}

