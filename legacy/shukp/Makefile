CFLAGS=-O2 -Wall -g

all: server client register

server: server.o server_error.o common.o response.o metadata.o io.o
	gcc $(CFLAGS) -o server server.o metadata.o server_error.o common.o response.o io.o
server.o: server.c server.h
	gcc -c $(CFLAGS) server.c

client: client.o metadata.o client_error.o common.o response.o io.o
	gcc $(CFLAGS) -o client client.o metadata.o client_error.o common.o response.o io.o
client.o: client.c
	gcc -c $(CFLAGS) client.c

register: super_register.c
	gcc $(CFLAGS) -o register super_register.c

metadata.o: metadata.c metadata.h
	gcc -c $(CFLAGS) metadata.c
server_error.o: server_error.c server_error.h
	gcc -c $(CFLAGS) server_error.c
client_error.o: client_error.c client_error.h
	gcc -c $(CFLAGS) client_error.c
common.o: common.c common.h
	gcc -c $(CFLAGS) common.c
response.o: response.c response.h
	gcc -c $(CFLAGS) response.c
io.o: io.c io.h
	gcc -c $(CFLAGS) io.c

clean:
	rm -f *.o server client register

