#ifndef FUSE_USE_VERSION
#define FUSE_USE_VERSION 25
#endif
#include <fuse/fuse.h>
#include "anyproc_fuse.h"
#include <string.h>
#include <errno.h>
#include "vfs.h"
#include <stdio.h>
#include <stdlib.h>

extern vfs_directory * anyproc_root_directory;

#define MAX_PATH_LAYER 4096
struct path {
	int is_root;
	char * data[MAX_PATH_LAYER];
};
typedef struct path path;

#define MAX_BUF_SIZE 4096
static path * parse_path(const char * request_path) {
	char spath[4096], * p = NULL;
	int i = 0;
	struct path * path_instance = NULL;

	if((path_instance = (path *) malloc(sizeof(path))) == NULL) return NULL;
	memset(path_instance, 0, sizeof(path));
	memset(spath, 0, MAX_BUF_SIZE);
	strncpy(spath, request_path, MAX_BUF_SIZE-1);

	p = strtok(spath, "/");
	while(p != NULL) {
		if((path_instance->data[i++] = strdup(p)) == NULL) return NULL;
		p = strtok(NULL, "/");
	}
	if(i == 0) path_instance->is_root = 1;

	return path_instance;
}

static void free_path(path * path) {
	int i = 0;

	for(i=0; i<MAX_PATH_LAYER && path->data[i]!=NULL; ++i)
		free(path->data[i]);
	free(path);
}

int anyproc_getattr(const char * spath, struct stat * stbuf) {
	int res = 0;
	path * request_path = NULL;

	if((request_path = parse_path(spath)) == NULL) return -ENOMEM;

	memset(stbuf, 0, sizeof(struct stat));
	if(request_path->is_root) {
		stbuf->st_mode = S_IFDIR | anyproc_root_directory->permission;
		stbuf->st_nlink = 2;
		stbuf->st_size = 4096;
	} else {
		int i = 0;
		vfs_directory * dir = NULL;

		dir = anyproc_root_directory;
		for(i=0; i<MAX_PATH_LAYER && request_path->data[i]!=NULL; ++i) {
			vfs_directory * target_dir = NULL;
			int found = 0;

			for(target_dir=dir->directories; target_dir!=NULL; target_dir=target_dir->next) {
				if(strcmp(request_path->data[i], target_dir->name) == 0) {
					dir = target_dir;
					found = 1;
					break;
				}
			}
			if(!found) {
				vfs_file * target_file = NULL;

				if(i<MAX_PATH_LAYER-1 && request_path->data[i+1] != NULL) {
					res=-ENOTDIR;
					goto ANYPROC_GETATTR_FREE;
				}

				for(target_file=dir->files; target_file!=NULL; target_file=target_file->next) {
					if(strcmp(request_path->data[i], target_file->name) == 0) {
						stbuf->st_mode = S_IFREG | target_file->permission;
						stbuf->st_nlink = 1;
						stbuf->st_size = target_file->content_length;
						goto ANYPROC_GETATTR_FREE;
					}
				}
				res = -ENOENT;
				goto ANYPROC_GETATTR_FREE;
			}
		}
		stbuf->st_mode = S_IFDIR | dir->permission;
		stbuf->st_nlink = 2;
		stbuf->st_size = 4096;
	}

ANYPROC_GETATTR_FREE:
	free_path(request_path);

	return res;
}

int anyproc_readdir(const char * spath, void * buf, fuse_fill_dir_t filler, off_t offset, struct fuse_file_info * fi) {
	int res = 0;
	struct path * request_path = NULL;
	vfs_directory * target_dir = NULL;

	if((request_path = parse_path(spath)) == NULL) return -ENOMEM;

	if(request_path->is_root) {
		target_dir = anyproc_root_directory;
	} else {
		int i = 0;
		vfs_directory * dir = anyproc_root_directory;

		for(i=0; i<MAX_PATH_LAYER && request_path->data[i]!=NULL; ++i) {
			int found = 0;
			vfs_directory * dir_iterator = NULL;

			for(dir_iterator=dir->directories; dir_iterator!=NULL; dir_iterator=dir_iterator->next) {
				if(strcmp(request_path->data[i], dir_iterator->name) == 0) {
					found = 1;
					dir = dir_iterator;
					break;
				}
			}
			if(!found) {
				if(i<MAX_PATH_LAYER-1 && request_path->data[i+1] != NULL) res=-ENOTDIR;
				else res=-ENOENT;
				goto ANYPROC_READDIR_FREE;
			}
		}
		target_dir = dir;
	}

	{
		vfs_directory * dir_iterator = NULL;
		vfs_file * file_iterator = NULL;
		struct stat statbuf;

		for(dir_iterator=target_dir->directories; dir_iterator!=NULL; dir_iterator=dir_iterator->next) {
			memset(&statbuf, 0, sizeof(struct stat));
			statbuf.st_size = 4096;
			statbuf.st_nlink = 2;
			statbuf.st_mode = S_IFDIR | dir_iterator->permission;
			filler(buf, dir_iterator->name, &statbuf, 0);
		}

		for(file_iterator=target_dir->files; file_iterator!=NULL; file_iterator=file_iterator->next) {
			memset(&statbuf, 0, sizeof(struct stat));
			statbuf.st_size = file_iterator->content_length;
			statbuf.st_nlink = 1;
			statbuf.st_mode = S_IFREG | file_iterator->permission;
			filler(buf, file_iterator->name, &statbuf, 0);
		}
	}


ANYPROC_READDIR_FREE:
	free_path(request_path);

	return res;
}

int anyproc_read(const char * spath, char * buf, size_t size, off_t offset, struct fuse_file_info * fi) {
	int res = 0;
	path * request_path = NULL;

	if((request_path = parse_path(spath)) == NULL) return -ENOMEM;

	if(request_path->is_root) {
		res = -EISDIR;
	} else {
		int i = 0;
		vfs_directory * target_dir = anyproc_root_directory;

		for(i=0; i<MAX_PATH_LAYER && request_path->data[i]!=NULL; ++i) {
			int found = 0;
			vfs_directory * dir_iterator = NULL;

			for(dir_iterator=target_dir->directories; dir_iterator!=NULL; dir_iterator=dir_iterator->next) {
				if(strcmp(request_path->data[i], dir_iterator->name) == 0) {
					found = 1;
					target_dir = dir_iterator;
					break;
				}
			}
			if(!found) {
				vfs_file * target_file = NULL;

				if(i<MAX_PATH_LAYER-1 && request_path->data[i+1] != NULL) {
					res = -ENOTDIR;
					goto ANYPROC_READ_FREE;
				}

				for(target_file=target_dir->files; target_file!=NULL; target_file=target_file->next) {
					if(strcmp(request_path->data[i], target_file->name) == 0) {
						if(target_file->content != 0) {
							memcpy(buf, target_file->content, size);
							res = target_file->content_length;
						}
						goto ANYPROC_READ_FREE;
					}
				}
				res = -ENOENT;
				goto ANYPROC_READ_FREE;
			}
		}
	}

ANYPROC_READ_FREE:
	free_path(request_path);

	return res;
}

int anyproc_write(const char * a, const char * b, size_t c, off_t d, struct fuse_file_info * e) {
	return 0;
}

int anyproc_open(const char * path, struct fuse_file_info * fi) {
//	if((fi->flags & 3) != O_RDONLY)
//		return -EACCES;
	return 0;
}

