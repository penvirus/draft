#ifndef __LIB_USOCK__
#define __LIB_USOCK__

/*
 * path: unix domain socket file
 * return: file descriptor
 */
int libusock_blocking_server(const char * path);

/*
 * path: unix domain socket file
 * return: file descriptor
 */
int libusock_nonblocking_server(const char * path);

/*
 * path: unix domain socket file
 * return: file descriptor
 */
int libusock_blocking_client(const char * path);

/*
 * path: unix domain socket file
 * return: file descriptor
 */
int libusock_nonblocking_client(const char * path);

#endif

