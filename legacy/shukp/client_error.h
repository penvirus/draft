#ifndef __ERROR_H__
#define __ERROR_H__

#include <stdarg.h>

/* prefix:
 * ce stands for 'Client Error' with a format string
 * cex stands for 'Client Error' without format string
 * */

#define CE_CODE_NORMAL_EXIT 0
void ce_normal_exit(const char * fmt, ...);
void cex_normal_exit(const char * fmt, ...);

#define CE_CODE_INSUFFICIENT_ARGUMENT 1
#define CE_CATEGORY_INSUFFICIENT_ARGUMENT "Insufficient Argument"
void ce_insufficient_argument(const char * fmt, ...);
void cex_insufficient_argument(const char * fmt, ...);

#define CE_CODE_INVALID_ARGUMENT 2
#define CE_CATEGORY_INVALID_ARGUMENT "Invalid Argument"
void ce_invalid_argument(const char * fmt, ...);
void cex_invalid_argument(const char * fmt, ...);

#define CE_CODE_CONNECTION_TIMEOUT 3
#define CE_CATEGORY_CONNECTION_TIMEOUT "Connection Timeout"
void ce_connection_timeout(const char * fmt, ...);
void cex_connection_timeout(const char * fmt, ...);

#define CE_CODE_CLIENT_INTERNAL_ERROR 4
#define CE_CATEGORY_CLIENT_INTERNAL_ERROR "Client Internal Error"
void ce_client_internal_error(const char * fmt, ...);
void cex_client_internal_error(const char * fmt, ...);

#define CE_CODE_SERVER_INTERNAL_ERROR 5
#define CE_CATEGORY_SERVER_INTERNAL_ERROR "Server Internal Error"
void ce_server_internal_error(const char * fmt, ...);
void cex_server_internal_error(const char * fmt, ...);

#endif

