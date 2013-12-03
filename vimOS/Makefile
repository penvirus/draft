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
	@mkdir -pv $(DIR_WORKING)
	@mkdir -pv $(DIR_DIST)
	@mkdir -pv $(DIR_DIST)/rootfs/
	@mkdir -pv $(DIR_DIST)/rootfs/dev/
	@mkdir -pv $(DIR_DIST)/rootfs/boot/
	@mkdir -pv $(DIR_DIST)/rootfs/etc/
	@mkdir -pv $(DIR_DIST)/rootfs/usr/
	test -e $(DIR_DIST)/rootfs/bin || ln -sv ./usr/bin $(DIR_DIST)/rootfs/bin

$(SUBDIRS): pre_build
	$(MAKE) -C $@

clean:
	@for sub in $(SUBDIRS); do \
	    $(MAKE) -C $$sub $@; \
	done
	@rm -rf $(DIR_WORKING)
	@rm -rf $(DIR_DIST)

.PHONY: all clean
