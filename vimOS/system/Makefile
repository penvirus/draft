include ../common.mk

ROOTFS := $(DIR_DIST)/rootfs
ROOTFS_PREFIX := $(DIR_DIST)/rootfs
ROOTFS_LIB := $(DIR_DIST)/rootfs/lib64
ROOTFS_ETC := $(DIR_DIST)/rootfs/etc
ROOTFS_VAR := $(DIR_DIST)/rootfs/var

BINUTILS := binutils-2.24.51
GCC := gcc-4.8.2
MPFR := mpfr-3.1.2
GMP := gmp-5.1.3
MPC := mpc-1.0.1
ISL := isl-0.11.1
CLOOG := cloog-0.18.0
GLIBC_LIBIDN := glibc-libidn-2.10.1
GLIBC := glibc-2.18

BASH := bash-4.2

GRUB_VERSION := 2.00

#PKGS += $(BASH)

all: toolchain all_packages

toolchain:
	make binutils
	make compiler
	test -e $(ROOTFS)/usr/lib || ln -s $(ROOTFS_LIB) $(ROOTFS)/usr/lib
	test -e $(ROOTFS)/lib || ln -s $(ROOTFS_LIB) $(ROOTFS)/lib
	test -e $(ROOTFS)/usr/lib64 || ln -s $(ROOTFS_LIB) $(ROOTFS)/usr/lib64
	test -e $(ROOTFS)/lib64 || ln -s $(ROOTFS_LIB) $(ROOTFS)/lib64
	make glibc

toolchain_clean: binutils_clean compiler_clean glibc_clean
	rm -f binutils
	rm -f compiler
	rm -f glibc

binutils:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(BINUTILS).tar.bz2 -C $(DIR_WORKING)
	@mkdir -p $(DIR_WORKING)/$(BINUTILS)/binutils-build
	@cd $(DIR_WORKING)/$(BINUTILS)/binutils-build; \
	    ../configure \
	    --prefix=$(ROOTFS_PREFIX) \
	    --libdir=$(ROOTFS_LIB) \
	    --sysconfdir=$(ROOTFS_ETC) \
	    --localstatedir=$(ROOTFS_VAR) \
	    --target=$(CROSS_COMPILE_TARGET) \
	    --with-sysroot=$(ROOTFS) \
	    --with-lib-path=$(ROOTFS_LIB) \
	    --with-sysroot=$(ROOTFS) \
	    --disable-nls \
	    --disable-werror \
	    && make -j4 && make install
	$(making-end)

binutils_clean:

$(ISL):
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(ISL); \
	    ./configure \
	    --prefix=$(ROOTFS_PREFIX) \
	    --libdir=$(ROOTFS_LIB) \
	    --sysconfdir=$(ROOTFS_ETC) \
	    --localstatedir=$(ROOTFS_VAR) \
	    --disable-dependency-tracking \
	    --disable-static \
	    --enable-silent-rules \
	    --disable-nls \
	    && make -j4 && make install
	$(making-end)

$(CLOOG):
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(CLOOG); \
	    ./configure \
	    --prefix=$(ROOTFS_PREFIX) \
	    --libdir=$(ROOTFS_LIB) \
	    --sysconfdir=$(ROOTFS_ETC) \
	    --localstatedir=$(ROOTFS_VAR) \
	    --disable-dependency-tracking \
	    --disable-static \
	    --enable-silent-rules \
	    --disable-nls \
	    && make -j4 && make install
	$(making-end)

compiler: $(ISL) $(CLOOG)
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@tar Jxf $(DIR_3RD_PARTY)/$(MPFR).tar.xz -C $(DIR_WORKING)/$(GCC)
	@mv $(DIR_WORKING)/$(GCC)/$(MPFR) $(DIR_WORKING)/$(GCC)/mpfr
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)/$(GCC)
	@mv $(DIR_WORKING)/$(GCC)/$(GMP) $(DIR_WORKING)/$(GCC)/gmp
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -C $(DIR_WORKING)/$(GCC)
	@mv $(DIR_WORKING)/$(GCC)/$(MPC) $(DIR_WORKING)/$(GCC)/mpc
	@cp replace_ld.sh $(DIR_WORKING)/$(GCC)/
	@cd $(DIR_WORKING)/$(GCC); sh replace_ld.sh $(DIR_DIST)/rootfs
	@sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' $(DIR_WORKING)/$(GCC)/gcc/configure
	@mkdir -p $(DIR_WORKING)/$(GCC)/gcc-build
	@cd $(DIR_WORKING)/$(GCC)/gcc-build; \
	    ../configure \
	    --prefix=$(ROOTFS_PREFIX) \
	    --libdir=$(ROOTFS_LIB) \
	    --sysconfdir=$(ROOTFS_ETC) \
	    --localstatedir=$(ROOTFS_VAR) \
	    --target=$(CROSS_COMPILE_TARGET) \
	    --with-local-prefix=$(ROOTFS) \
	    --with-sysroot=$(ROOTFS) \
	    --with-newlib \
	    --disable-libstdc++-v3 \
	    --without-headers \
	    --disable-nls \
	    --disable-shared \
	    --disable-decimal-float \
	    --disable-threads \
	    --disable-libatomic \
	    --disable-libgomp \
	    --disable-libitm \
	    --disable-libmudflap \
	    --disable-libquadmath \
	    --disable-libsanitizer \
	    --disable-libssp \
	    --disable-libstdcxx \
	    --disable-multilib \
	    --enable-languages=c,c++ \
	    && make -j4 && make install
	$(making-end)
	    #--with-native-system-header-dir=$(DIR_DIST)/rootfs/usr/include
	    #--with-build-sysroot=$(DIR_DIST)/rootfs

compiler_clean:
	rm -f $(ISL) $(CLOOG)

kernel-headers:
	$(making-start)
	@cd $(DIR_3RD_PARTY); tar Jxf linux-$(KERNEL_VERSION).tar.xz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/linux-$(KERNEL_VERSION)/; \
	    make headers_check && \
	    make INSTALL_HDR_PATH=$(ROOTFS_PREFIX) ARCH=x86 headers_install
	@rm -rf $(DIR_WORKING)/linux-$(KERNEL_VERSION)
	$(making-end)

glibc: kernel-headers
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GLIBC).tar.xz -C $(DIR_WORKING)
	@mkdir -p $(DIR_WORKING)/$(GLIBC)/glibc_build
	@cd $(DIR_WORKING)/$(GLIBC)/glibc_build; \
	    CC=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    CXX=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
	    ../configure \
	    --prefix=$(ROOTFS_PREFIX) \
	    --libdir=$(ROOTFS_LIB) \
	    --sysconfdir=$(ROOTFS_ETC) \
	    --localstatedir=$(ROOTFS_VAR) \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --enable-stackguard-randomization \
	    --enable-add-ons=nptl \
	    --with-headers=$(ROOTFS_PREFIX)/include \
	    --enable-kernel=2.6.32 \
	    --disable-nls \
	    libc_cv_forced_unwind=yes \
	    libc_cv_c_cleanup=yes \
	    libc_cv_ctors_header=yes \
	    && make -j4 && make install
	$(making-end)
	    #libc_cv_ld_no_whole_archive=yes \

glibc_clean:
	rm -f kernel-headers

libstdc-plus-plus:
	$(making-start)
	@mkdir -p $(DIR_WORKING)/$(GCC)/libc++-build
	@cd $(DIR_WORKING)/$(GCC)/libc++-build; \
	    export PATH=$(DIR_DIST)/rootfs/usr/bin:$$PATH; \
	    ../libstdc++-v3/configure \
	    --prefix=$(ROOTFS_PREFIX) \
	    --libdir=$(ROOTFS_LIB) \
	    --sysconfdir=$(ROOTFS_ETC) \
	    --localstatedir=$(ROOTFS_VAR) \
	    --disable-multilib \
	    --disable-shared \
	    --disable-nls \
	    --disable-libstdcxx-threads \
	    --disable-libstdcxx-pch \
	    && make && make install
	$(making-end)

all_packages:
	@install -m 775 init $(DIR_DIST)/rootfs/
	@for pkg in $(PKGS); do \
	    $(MAKE) $$pkg || exit 1; \
	done

$(BASH):
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(BASH).tar.gz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(BASH); \
	    ./configure \
	    --prefix=$(ROOTFS_PREFIX) \
	    --libdir=$(ROOTFS_LIB) \
	    --sysconfdir=$(ROOTFS_ETC) \
	    --localstatedir=$(ROOTFS_VAR) \
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
	    && make -j4 && make install
	#@cp /lib64/libdl.so.2 $(DIR_DIST)/rootfs/lib64/
	#@cp /lib64/libc.so.6 $(DIR_DIST)/rootfs/lib64/
	#@cp /lib64/ld-linux-x86-64.so.2 $(DIR_DIST)/rootfs/lib64/
	#@cp /lib64/libtinfo.so.5 $(DIR_DIST)/rootfs/lib64/
	$(making-end)

clean: toolchain_clean
	@rm -f $(PKGS)
	@rm -f *.making

.PHONY: all clean
