#include <unistd.h>
#include "common.h"
#include "io.h"
#include <stdlib.h>

int io(int ifd, int ofd, int len) {
	char buf[BUFFER_LEN_MAX];
	int readn, writen;
	char * writep;
	int origin_len;

	origin_len = len;

	while(len > 0) {
		if((readn = read(ifd, buf, len < BUFFER_LEN_MAX ? len : BUFFER_LEN_MAX)) == -1) return -1;
		else if(readn == 0) return 0;

		len -= readn;
		writep = buf;

		while(readn > 0) {
			if((writen = write(ofd, writep, readn)) == -1) return -1;
			else if(writen == 0) return 0;

			readn -= writen;
			writep += writen;
		}
	}

	return origin_len;
}

