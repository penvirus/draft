#ifndef __ANYPROC_FUSE_H__
#define __ANYPROC_FUSE_H__

int anyproc_getattr(const char * path, struct stat * stbuf);
int anyproc_readdir(const char * path, void * buf, fuse_fill_dir_t filler, off_t offset, struct fuse_file_info * fi);
int anyproc_read(const char * spath, char * buf, size_t size, off_t offset, struct fuse_file_info * fi);
int anyproc_write(const char * a, const char * b, size_t c, off_t d, struct fuse_file_info * e);
int anyproc_open(const char * path, struct fuse_file_info * fi);

#endif

