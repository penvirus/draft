#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "metadata.h"
#include "common.h"
#include "client_error.h"

static struct metadata * metadata = NULL;

static int _add_metadata(const char * datastring, char type) {
	char buf[BUFFER_LEN_MAX];
	char * equal_sign;
	struct metadata * new_metadata;

	memset(buf, 0, BUFFER_LEN_MAX);
	strncpy(buf, datastring, BUFFER_LEN_MAX - 1);

	if((equal_sign = strchr(buf, '=')) == NULL) return -1;

	*equal_sign = 0;

	if((new_metadata = (struct metadata *) malloc(sizeof(struct metadata))) == NULL) return -1;
	memset(new_metadata, 0, sizeof(struct metadata));
	if((new_metadata->key = strdup(buf)) == NULL) return -1;
	if((new_metadata->value = strdup(equal_sign + 1)) == NULL) return -1;
	new_metadata->type = type;

	if(metadata == NULL) {
		metadata = new_metadata;
	} else {
		struct metadata * tail;

		for(tail=metadata; tail->next!=NULL; tail=tail->next) ;
		tail->next = new_metadata;
	}

	return 0;
}

int add_metadata_from_string(const char * datastring) {
	return _add_metadata(datastring, 0);
}

int add_metadata_from_file(const char * datafile) {
	return 0;
}

int add_inputfile_metadata_from_string(const char * datastring) {
	return _add_metadata(datastring, 'f');
}

int add_inputfile_metadata_from_file(const char * datafile) {
	return 0;
}

struct metadata * get_metadata() {
	return metadata;
}

void free_metadata() {
	struct metadata * iterator, * previous;

	for(iterator=metadata; iterator!=NULL; ) {
		previous = iterator;
		iterator = iterator->next;
		free(previous->key);
		free(previous->value);
		free(previous);
	}
}

#ifdef DEBUG
void list_metadata() {
	struct metadata * iterator;
	FILE * fp;

	fp = fopen("/tmp/log.txt", "a");
	for(iterator=metadata; iterator!=NULL; iterator=iterator->next)
		fprintf(fp, "key [%s] ==> value [%s] type[%c]\n", iterator->key, iterator->value, iterator->type);
	fclose(fp);
}
#endif

