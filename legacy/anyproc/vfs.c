#include "vfs.h"
#include <libxml/parser.h>
#include <string.h>

struct processing_node {
	xmlNode * data;
	vfs_directory * data2;
	struct processing_node * next;
};
typedef struct processing_node processing_node;

static void add_directory(vfs_directory * parent, vfs_directory * child) {
	vfs_directory * tail = NULL;

	if(parent->directories == NULL) {
		parent->directories = child;
	} else {
		for(tail=parent->directories; tail->next!=NULL; tail=tail->next) ;
		tail->next = child;
	}

	child->next = NULL;
	child->parent = parent;
}

static void add_file(vfs_directory * parent, vfs_file * child) {
	vfs_file * tail = NULL;

	if(parent->files == NULL) {
		parent->files = child;
	} else {
		for(tail=parent->files; tail->next!=NULL; tail=tail->next) ;
		tail->next = child;
	}

	child->next = NULL;
	child->parent = parent;
}

static void add_processing_node(processing_node * head, processing_node * new_one) {
	processing_node * tail = NULL;

	for(tail=head; tail->next!=NULL; tail=tail->next) ;
	tail->next = new_one;
}

static vfs_directory * new_vfs_directory() {
	vfs_directory * new_one = NULL;

	if((new_one = (vfs_directory *) malloc(sizeof(vfs_directory))) == NULL) return NULL;
	memset(new_one, 0, sizeof(vfs_directory));
	return new_one;
}

static vfs_file * new_vfs_file() {
	vfs_file * new_one = NULL;

	if((new_one = (vfs_file *) malloc(sizeof(vfs_file))) == NULL) return NULL;
	memset(new_one, 0, sizeof(vfs_file));
	return new_one;
}

static processing_node * new_processing_node() {
	processing_node * new_one = NULL;

	if((new_one = (processing_node *) malloc(sizeof(processing_node))) == NULL) return NULL;
	memset(new_one, 0, sizeof(processing_node));
	return new_one;
}

vfs_directory * build_vfs_from_xml(const char * xml_filename) {
	xmlDoc * doc = NULL;
	xmlNode * xml_root_node = NULL;
	vfs_directory * root_directory = NULL;
	processing_node * processing_queue = NULL;

	if((doc = xmlReadFile(xml_filename, NULL, 0)) == NULL) return NULL;
	if((xml_root_node = xmlDocGetRootElement(doc)) == NULL) return NULL;
	if((processing_queue = new_processing_node()) == NULL) return NULL;
	processing_queue->data = xml_root_node;

	while(processing_queue != NULL) {
		xmlNode * current_xml_node = NULL;
		vfs_directory * parent_vfs_directory = NULL;

		current_xml_node=processing_queue->data;
		parent_vfs_directory=processing_queue->data2;

		if(current_xml_node->children != NULL) {
			if(current_xml_node->children->next != NULL) {
				/* a vfs directory */
				vfs_directory * new_directory = NULL;
				xmlNode * iterator = NULL;

				if((new_directory = new_vfs_directory()) == NULL) return NULL;
				new_directory->name = strdup((char *) current_xml_node->name);
				new_directory->permission |= 0755;

				if(root_directory == NULL) {
					root_directory = new_directory;
				} else {
					add_directory(parent_vfs_directory, new_directory);
				}
				for(iterator=current_xml_node->children; iterator!=NULL; iterator=iterator->next) {
					processing_node * new_node = NULL;

					if(iterator->type != XML_ELEMENT_NODE) continue;

					if((new_node = new_processing_node()) == NULL) return NULL;
					new_node->data = iterator;
					new_node->data2 = new_directory;
					add_processing_node(processing_queue, new_node);
				}
			} else {
				/* a vfs file */
				vfs_file * new_file = NULL;

				if((new_file = new_vfs_file()) == NULL) return NULL;
				new_file->permission |= 0444;
				new_file->name = strdup((char *) current_xml_node->name);
				new_file->content = strdup((char *) current_xml_node->children->content);
				new_file->content_length = strlen((char *) current_xml_node->children->content);
				add_file(parent_vfs_directory, new_file);
			}
		} else {
			/* a vfs file */
			vfs_file * new_file = NULL;

			if((new_file = new_vfs_file()) == NULL) return NULL;
			new_file->permission |= 0444;
			new_file->name = strdup((char *) current_xml_node->name);
			new_file->content = NULL;
			new_file->content_length = 0;
			add_file(parent_vfs_directory, new_file);
		}

		{
			processing_node * node_to_free = processing_queue;
			processing_queue = processing_queue->next;
			free(node_to_free);
		}
	}

	xmlFreeDoc(doc);
	xmlCleanupParser();

	return root_directory;
}

void print_vfs(const vfs_directory * root_directory) {
	{
		vfs_directory * dir = NULL;

		for(dir=root_directory->directories; dir!=NULL; dir=dir->next) {
			printf("%s/ %o\n", dir->name, dir->permission);
			print_vfs(dir);
		}
	}

	{
		vfs_file * file = NULL;

		for(file=root_directory->files; file!=NULL; file=file->next) {
			printf("%s %o %d %s\n", file->name, file->permission, file->content_length, file->content);
		}
	}
}

