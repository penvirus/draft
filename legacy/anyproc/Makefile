CFLAGS=-m32 -D_FILE_OFFSET_BITS=64 -g -Wall
LD_FLAGS=-L/usr/local/lib -lfuse -lxml2 -I/usr/include/libxml2

anyproc: anyproc_main.o anyproc_fuse.o vfs.o
	gcc $(CFLAGS) $(LD_FLAGS) anyproc_main.o anyproc_fuse.o vfs.o -o anyproc
anyproc_main.o: anyproc_main.c
	gcc $(CFLAGS) $(LD_FLAGS) -c anyproc_main.c
anyproc_fuse.o: anyproc_fuse.c
	gcc $(CFLAGS) $(LD_FLAGS) -c anyproc_fuse.c
vfs.o: vfs.c
	gcc $(CFLAGS) $(LD_FLAGS) -c vfs.c
clean:
	rm -f *.o anyproc
