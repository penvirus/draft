#ifndef __VFS_H__
#define __VFS_H__

struct vfs_directory;
struct vfs_file;

struct vfs_directory {
	char * name;
	int permission;
	struct vfs_directory * directories;
	struct vfs_file * files;
	struct vfs_directory * parent;
	struct vfs_directory * next;
};
typedef struct vfs_directory vfs_directory;

struct vfs_file {
	char * name;
	int permission;
	char * content;
	int content_length;
	struct vfs_directory * parent;
	struct vfs_file * next;
};
typedef struct vfs_file vfs_file;

vfs_directory * build_vfs_from_xml(const char * xml_filename);
void print_vfs(const vfs_directory * root_directory);

#endif

