include common.mk

DIR_3RD_PARTY 	:= $(shell pwd)/3rd_party
DIR_WORKING 	:= $(shell pwd)/build
DIR_DIST 	:= $(shell pwd)/dist
export DIR_3RD_PARTY
export DIR_WORKING
export DIR_DIST

SUBDIRS = system kernel cdiso

all: $(SUBDIRS)

pre_build:
	@mkdir -p $(DIR_WORKING)
	@mkdir -p $(DIR_DIST)
	@mkdir -p $(DIR_DIST)/rootfs/
	@mkdir -p $(DIR_DIST)/rootfs/boot/
	@mkdir -p $(DIR_DIST)/rootfs/bin/
	@mkdir -p $(DIR_DIST)/rootfs/etc/
	@mkdir -p $(DIR_DIST)/rootfs/usr/
	@mkdir -p $(DIR_DIST)/rootfs/lib/
	@mkdir -p $(DIR_DIST)/rootfs/lib64/

$(SUBDIRS): pre_build
	$(MAKE) -C $@

clean:
	@for sub in $(SUBDIRS); do \
	    $(MAKE) -C $$sub $@; \
	done
	@rm -rf $(DIR_WORKING)
	@rm -rf $(DIR_DIST)

.PHONY: all clean
