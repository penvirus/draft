CC = /usr/bin/gcc
CFLAGS = -Wall -O2
LIBS = -lusock

all: form jailer

form: form.o
	$(CC) $(CFLAGS) $(LIBS) -o form form.o
form.o: form.c
	$(CC) $(CFLAGS) -c form.c
jailer: jailer.o
	$(CC) $(CFLAGS) $(LIBS) -o jailer jailer.o
jailer.o: jailer.c
	$(CC) $(CFLAGS) -c jailer.c

clean:
	rm -f *.o form jailer


