include ../common.mk

ROOTFS := $(DIR_DIST)/rootfs
ROOTFS_PREFIX := $(DIR_DIST)/rootfs/usr

INSTALL_DIRS := \
    --prefix=$(ROOTFS_PREFIX) \
    --libdir=$(ROOTFS_PREFIX)/lib64 \
    --sysconfdir=$(ROOTFS)/etc \
    --localstatedir=$(ROOTFS)/var

include toolchain.mk

BASH := bash-4.2
COREUTIL := coreutils-8.21

PKGS += $(BASH)
PKGS += $(COREUTIL)

all: toolchain all_packages

all_packages:
	@install -m 775 init $(ROOTFS)
	@for pkg in $(PKGS); do \
	    $(MAKE) $$pkg || exit 1; \
	done

$(BASH):
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(BASH).tar.gz -C $(DIR_WORKING)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    CC=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --enable-alias \
	    --enable-arith-for-command \
	    --enable-array-variables \
	    --enable-brace-expansion \
	    --enable-debugger \
	    --enable-directory-stack \
	    --enable-dparen-arithmetic \
	    --enable-help-builtin \
	    --enable-history \
	    --enable-job-control \
	    --enable-net-redirections \
	    --enable-readline \
	    --disable-nls \
	    --enable-select \
	    --disable-rpath \
	    --with-gnu-malloc \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

$(COREUTIL):
	$(making-start)
	@tar xJf $(DIR_3RD_PARTY)/$(COREUTIL).tar.xz -C $(DIR_WORKING)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    CC=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --enable-install-program=hostname \
	    --disable-nls \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

clean: toolchain_clean
	@rm -f $(PKGS)
	@rm -f *.making

.PHONY: all clean
