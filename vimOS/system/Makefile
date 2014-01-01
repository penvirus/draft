include ../common.mk

ROOTFS := $(DIR_DIST)/rootfs
ROOTFS_PREFIX := $(DIR_DIST)/rootfs/usr
INSTALL_DIRS := \
	--prefix=$(ROOTFS_PREFIX) \
	--libdir=$(ROOTFS_PREFIX)/lib64 \
	--sysconfdir=$(ROOTFS)/etc \
	--localstatedir=$(ROOTFS)/var

FAKE_INSTALL_DIRS := \
	--prefix=/usr \
	--libdir=/usr/lib64 \
	--sysconfdir=/etc \
	--localstatedir=/var
	
TEMP_ROOTFS := $(DIR_WORKING)/temp_rootfs
TEMP_ROOTFS_PREFIX := $(DIR_WORKING)/temp_rootfs/usr
TEMP_INSTALL_DIRS := \
	--prefix=$(TEMP_ROOTFS_PREFIX) \
	--libdir=$(TEMP_ROOTFS_PREFIX)/lib64 \
	--sysconfdir=$(TEMP_ROOTFS)/etc \
	--localstatedir=$(TEMP_ROOTFS)/var

all:
	@mkdir -pv $(TEMP_ROOTFS)
	@mkdir -pv $(TEMP_ROOTFS)/usr
	@mkdir -pv $(TEMP_ROOTFS)/usr/bin
	@mkdir -pv $(TEMP_ROOTFS)/usr/lib64
	@mkdir -pv $(TEMP_ROOTFS)/etc
	@mkdir -pv $(TEMP_ROOTFS)/var
	@test -e $(TEMP_ROOTFS)/bin || ln -sv ./usr/bin $(TEMP_ROOTFS)/bin
	@test -e $(TEMP_ROOTFS)/lib || ln -sv ./usr/lib64 $(TEMP_ROOTFS)/lib
	@test -e $(TEMP_ROOTFS)/lib64 || ln -sv ./usr/lib64 $(TEMP_ROOTFS)/lib64
	@test -e $(TEMP_ROOTFS)/usr/lib || ln -sv ./lib64 $(TEMP_ROOTFS)/usr/lib
	@$(MAKE) temp_toolchain
	@$(MAKE) toolchain
	@$(MAKE) packages

clean:
	@$(MAKE) packages_clean
	@$(MAKE) toolchain_clean
	@$(MAKE) temp_toolchain_clean
	@rm -f *.making

.PHONY: all clean

include temp_toolchain.mk
include toolchain.mk
include packages.mk
