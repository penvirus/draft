#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <stddef.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <fcntl.h>

#define MAX_BACKLOG 1024

static int get_server(const char * path, int nonblocking) {
	int server_fd;
	struct sockaddr_un server_addr;
	socklen_t server_addr_len;
	int fcntl_flag;

	if((server_fd = socket(AF_UNIX, SOCK_STREAM, 0)) == -1)
		return -1;
	if(nonblocking) {
		if((fcntl_flag = fcntl(server_fd, F_GETFL)) == -1)
			return -1;
		if(fcntl(server_fd, F_SETFL, fcntl_flag | O_NONBLOCK) == -1)
			return -1;
	}

	memset(&server_addr, 0, sizeof(struct sockaddr_un));
	server_addr.sun_family = AF_UNIX;
	strncpy(server_addr.sun_path, path, sizeof(server_addr.sun_path) - 1);
	if(unlink(path) == -1 && errno != ENOENT)
		return -1;
	server_addr_len = offsetof(struct sockaddr_un, sun_path) + strlen(server_addr.sun_path);
	if(bind(server_fd, (struct sockaddr *) &server_addr, server_addr_len) == -1)
		return -1;
	if(listen(server_fd, MAX_BACKLOG) == -1)
		return -1;

	return server_fd;
}

int libusock_blocking_server(const char * path) {
	return get_server(path, 0);
}

int libusock_nonblocking_server(const char * path) {
	return get_server(path, 1);
}

static int get_client(const char * path, int nonblocking) {
	int client_fd;
	struct sockaddr_un server_addr;
	socklen_t server_addr_len;
	int fcntl_flag;

	if((client_fd = socket(AF_UNIX, SOCK_STREAM, 0)) == -1)
		return -1;
	if(nonblocking) {
		if((fcntl_flag = fcntl(client_fd, F_GETFL)) == -1)
			return -1;
		if(fcntl(client_fd, F_SETFL, fcntl_flag | O_NONBLOCK) == -1)
			return -1;
	}

	memset(&server_addr, 0, sizeof(struct sockaddr_un));
	server_addr.sun_family = AF_UNIX;
	strncpy(server_addr.sun_path, path, sizeof(server_addr.sun_path) - 1);
	server_addr_len = offsetof(struct sockaddr_un, sun_path) + strlen(server_addr.sun_path);
	if(connect(client_fd, (struct sockaddr *) &server_addr, server_addr_len) == -1)
		return -1;

	return client_fd;
}

int libusock_blocking_client(const char * path) {
	return get_client(path, 0);
}

int libusock_nonblocking_client(const char * path) {
	return get_client(path, 1);
}

