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

BASH := bash-4.2
COREUTIL := coreutils-8.21
STRACE := strace-4.8
NCURSES := ncurses-5.9
LESS := less-451
VIM := vim-7.4

PKGS += $(BASH)
PKGS += $(COREUTIL)
PKGS += $(STRACE)
PKGS += $(NCURSES)
PKGS += $(LESS)
#PKGS += $(VIM)

all:
	@mkdir -pv $(TEMP_ROOTFS)
	@mkdir -pv $(TEMP_ROOTFS)/usr
	@mkdir -pv $(TEMP_ROOTFS)/usr/bin
	@mkdir -pv $(TEMP_ROOTFS)/usr/lib64
	@test -e $(TEMP_ROOTFS)/bin || ln -sv ./usr/bin $(TEMP_ROOTFS)/bin
	@test -e $(TEMP_ROOTFS)/lib || ln -sv ./usr/lib64 $(TEMP_ROOTFS)/lib
	@test -e $(TEMP_ROOTFS)/lib64 || ln -sv ./usr/lib64 $(TEMP_ROOTFS)/lib64
	@test -e $(TEMP_ROOTFS)/usr/lib || ln -sv ./lib64 $(TEMP_ROOTFS)/usr/lib
	make temp_toolchain
	make toolchain
	make all_packages

include toolchain.mk

all_packages:
	@install -m 775 init $(ROOTFS)
	@for pkg in $(PKGS); do \
		$(MAKE) $$pkg || exit 1; \
	done

$(BASH):
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$@.tar.gz -C $(DIR_WORKING)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(INSTALL_DIRS) \
		--host=x86_64-unknown-linux-gnu \
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
		--with-gnu-malloc
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)

$(COREUTIL):
	$(making-start)
	@tar xJf $(DIR_3RD_PARTY)/$@.tar.xz -C $(DIR_WORKING)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(INSTALL_DIRS) \
		--host=x86_64-unknown-linux-gnu \
		--disable-silent-rules \
		--disable-dependency-tracking \
		--enable-install-program=hostname \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)
	exit 1
		#--enable-threads=posix

$(STRACE):
	$(making-start)
	@tar xJf $(DIR_3RD_PARTY)/$(STRACE).tar.xz -C $(DIR_WORKING)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		CC=$(TEMP_ROOTFS_PREFIX)/bin/gcc \
		../configure \
		$(INSTALL_DIRS) \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)

$(NCURSES):
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$@.tar.gz -C $(DIR_WORKING)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(INSTALL_DIRS) \
		--with-shared \
		--without-debug \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)

$(LESS):
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$@.tar.gz -C $(DIR_WORKING)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		LDFLAGS="-L$(ROOTFS_PREFIX)/lib64" \
		../configure \
		$(INSTALL_DIRS) \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)


$(VIM):
	$(making-start)
	@tar xjf $(DIR_3RD_PARTY)/$@.tar.bz2 -C $(DIR_WORKING)
	@mv $(DIR_WORKING)/vim74 $(DIR_WORKING)/$@
	@cd $(DIR_WORKING)/$@; \
		CC=$(TEMP_ROOTFS_PREFIX)/bin/gcc \
		./configure \
		$(INSTALL_DIRS) \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)

clean:
	make temp_toolchain_clean
	make toolchain_clean
	@rm -f $(PKGS)
	@rm -f *.making

.PHONY: all clean
