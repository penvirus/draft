#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <ctype.h>
#include "common.h"
#include "error.h"

int create_directory(const char * directory) {
	struct stat statbuf;

	/* TODO: check file type, permission, owner ... */
	memset(&statbuf, 0, sizeof(struct stat));
	if(stat(directory, &statbuf) == -1 && errno != ENOENT) return -1;

	if(mkdir(directory, 0777) == -1) {
		if(errno == EEXIST) return 0;
		else return -1;
	}
	/* I don't know why mkdir does not set right permission?! */
	if(chmod(directory, 0777) == -1) return -1;

	return 0;
}

int validInteger(const char * int_string) {
	int i;

	if(strlen(int_string) != 1 && int_string[0] == '0')
		return 0;
	for(i=0; int_string[i]; ++i)
		if(!isdigit(int_string[i]))
			return 0;

	return 1;
}

