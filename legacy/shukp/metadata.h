#ifndef __METADATA_H__
#define __METADATA_H__

struct metadata {
	char * key;
	char * value;
	char type;	/* 0: default, f: file */
	struct metadata * next;
};

int add_metadata_from_string(const char * datastring);
int add_metadata_from_file(const char * datafile);
int add_inputfile_metadata_from_string(const char * datastring);
int add_inputfile_metadata_from_file(const char * datafile);

struct metadata * get_metadata();
void free_metadata();

#ifdef DEBUG
void list_metadata();
#endif

#endif

