#ifndef __SERVER_ERROR_H__
#define __SERVER_ERROR_H__

#include <stdarg.h>

/*
 * se stands for 'Server Error' with error string
 * sex stands for 'Server Error' without error string
 */

void se_error(char * fmt, ...);
void sex_error(char * fmt, ...);

void send_continue_response();
void send_sending_response(int length);
void send_ok_response();
void send_warning_response(const char * warning_msg);
void send_request_rejected_response();
void send_bad_request_response();
void send_insufficient_metadata_response();
void send_internal_error_response(const char * error_msg);

#endif

