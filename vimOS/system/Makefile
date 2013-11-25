include ../common.mk

BINUTILS := binutils-2.24.51
BINUTILS := binutils-2.23.52
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

#PKGS += $(BINUTILS)
#PKGS += $(GCC)
#PKGS += $(GLIBC)
PKGS += $(BASH)

all: toolchain all_packages

toolchain:
	make binutils
	make compiler
	test -e $(DIR_DIST)/rootfs/usr/lib || ln -s lib64 $(DIR_DIST)/rootfs/usr/lib
	test -e $(DIR_DIST)/rootfs/lib || ln -s ./usr/lib64 $(DIR_DIST)/rootfs/lib
	test -e $(DIR_DIST)/rootfs/lib64 || ln -s ./usr/lib64 $(DIR_DIST)/rootfs/lib64
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
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --libdir=$(DIR_DIST)/rootfs/usr/lib64 \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/var \
	    --with-build-sysroot=$(DIR_DIST)/rootfs \
	    --target=$(CROSS_COMPILE_TARGET) \
	    --with-sysroot \
	    --disable-nls \
	    && make -j4 && make install
	$(making-end)

binutils_clean:

$(ISL):
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(ISL); \
	    ./configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --libdir=$(DIR_DIST)/rootfs/usr/lib64 \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/var \
	    --disable-dependency-tracking \
	    --disable-static \
	    --enable-silent-rules \
	    && make && make install
	$(making-end)

$(CLOOG):
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(CLOOG); \
	    ./configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --libdir=$(DIR_DIST)/rootfs/usr/lib64 \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/var \
	    --disable-dependency-tracking \
	    --disable-static \
	    --enable-silent-rules \
	    && make && make install
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
	#@cp replace_ld.sh $(DIR_WORKING)/$(GCC)/
	#@cd $(DIR_WORKING)/$(GCC); sh replace_ld.sh $(DIR_DIST)/rootfs
	@sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' $(DIR_WORKING)/$(GCC)/gcc/configure
	@mkdir -p $(DIR_WORKING)/$(GCC)/gcc-build
	@cd $(DIR_WORKING)/$(GCC)/gcc-build; \
	    ../configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --libdir=$(DIR_DIST)/rootfs/usr/lib64 \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/rootfs/var \
	    --with-build-sysroot=$(DIR_DIST)/rootfs \
	    --target=$(CROSS_COMPILE_TARGET) \
	    --with-newlib \
	    --disable-libstdc++-v3 \
	    --without-headers \
	    --with-local-prefix=$(DIR_DIST)/rootfs/usr \
	    --with-native-system-header-dir=$(DIR_DIST)/rootfs/usr/include \
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

compiler_clean:
	rm -f $(ISL) $(CLOOG)

kernel-headers:
	$(making-start)
	@cd $(DIR_3RD_PARTY); tar Jxf linux-$(KERNEL_VERSION).tar.xz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/linux-$(KERNEL_VERSION)/; \
	    make headers_check && \
	    make INSTALL_HDR_PATH=$(DIR_DIST)/rootfs/usr ARCH=x86 headers_install
	@rm -rf $(DIR_WORKING)/linux-$(KERNEL_VERSION)
	$(making-end)

glibc: kernel-headers
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GLIBC).tar.xz -C $(DIR_WORKING)
	@mkdir -p $(DIR_WORKING)/$(GLIBC)/glibc_build
	@cd $(DIR_WORKING)/$(GLIBC)/glibc_build; \
	    CC=$(DIR_DIST)/rootfs/usr/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    CXX=$(DIR_DIST)/rootfs/usr/bin/$(CROSS_COMPILE_TARGET)-g++ \
	    ../configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --libdir=$(DIR_DIST)/rootfs/usr/lib64 \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/rootfs/var \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --enable-stackguard-randomization \
	    --enable-add-ons=nptl \
	    --with-headers=$(DIR_DIST)/rootfs/usr/include \
	    --enable-kernel=2.6.32 \
	    --disable-nls \
	    libc_cv_forced_unwind=yes \
	    libc_cv_c_cleanup=yes \
	    libc_cv_ctors_header=yes \
	    libc_cv_ld_no_whole_archive=yes \
	    && make -j4 && make install
	$(making-end)

glibc_clean:
	rm -f kernel-headers

libstdc-plus-plus:
	$(making-start)
	@mkdir -p $(DIR_WORKING)/$(GCC)/libc++-build
	@cd $(DIR_WORKING)/$(GCC)/libc++-build; \
	    export PATH=$(DIR_DIST)/rootfs/usr/bin:$$PATH; \
	    ../libstdc++-v3/configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --libdir=$(DIR_DIST)/rootfs/usr/lib64 \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/rootfs/var \
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
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --libdir=$(DIR_DIST)/rootfs/usr/lib64 \
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
