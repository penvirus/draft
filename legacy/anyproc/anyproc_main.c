#ifndef FUSE_USE_VERSION
#define FUSE_USE_VERSION 25
#endif
#include <fuse/fuse.h>
#include "anyproc_fuse.h"
#include "vfs.h"
#include <err.h>

static struct fuse_operations anyproc_operations = {
	.getattr= anyproc_getattr,
	.readdir= anyproc_readdir,
	.read	= anyproc_read,
	.open	= anyproc_open,
	.write	= anyproc_write,
};

vfs_directory * anyproc_root_directory = NULL;

int main(int argc, char ** argv) {

	anyproc_root_directory = build_vfs_from_xml("/dev/shm/anycfg.xml");
	if(anyproc_root_directory == NULL)
		err(1, "build_vfs_from_xml");

//	print_vfs(anyproc_root_directory);

	return fuse_main(argc, argv, &anyproc_operations);
}
