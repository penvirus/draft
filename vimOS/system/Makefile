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

LINUXTHREAD := glibc-linuxthreads-2.5

BASH := bash-4.2

GRUB_VERSION := 2.00

#PKGS += $(BINUTILS)
#PKGS += $(GCC)
#PKGS += $(GLIBC)
PKGS += $(BASH)

all: toolchain all_packages

toolchain:
	make cross-linker
	make cross-compiler
	make kernel-headers
	make glibc
	#make libstdc-plus-plus

toolchain_clean:
	rm -f cross-linker
	rm -f cross-compiler
	rm -f kernel-headers
	rm -f glibc
	rm -f libstdc-plus-plus

cross-linker:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(BINUTILS).tar.bz2 -C $(DIR_WORKING)
	@mkdir -p $(DIR_WORKING)/$(BINUTILS)/binutils-build
	@cd $(DIR_WORKING)/$(BINUTILS)/binutils-build; ../configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/var \
	    --libdir=$(DIR_DIST)/rootfs/lib64 \
	    --enable-ld=yes \
	    --disable-nls \
	    && make && make install
	$(making-end)

cross-compiler:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@tar Jxf $(DIR_3RD_PARTY)/$(MPFR).tar.xz -C $(DIR_WORKING)/$(GCC)
	@mv $(DIR_WORKING)/$(GCC)/$(MPFR) $(DIR_WORKING)/$(GCC)/mpfr
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)/$(GCC)
	@mv $(DIR_WORKING)/$(GCC)/$(GMP) $(DIR_WORKING)/$(GCC)/gmp
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -C $(DIR_WORKING)/$(GCC)
	@mv $(DIR_WORKING)/$(GCC)/$(MPC) $(DIR_WORKING)/$(GCC)/mpc
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)/$(GCC)
	@mkdir -p $(DIR_WORKING)/$(GCC)/isl
	@cd $(DIR_WORKING)/$(GCC)/$(ISL); \
	    ./configure \
	    --prefix=$(DIR_WORKING)/$(GCC)/isl \
	    && make && make install
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)/$(GCC)
	@mkdir -p $(DIR_WORKING)/$(GCC)/cloog
	@cd $(DIR_WORKING)/$(GCC)/$(CLOOG); \
	    ./configure \
	    --prefix=$(DIR_WORKING)/$(GCC)/cloog \
	    && make && make install
	@sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' $(DIR_WORKING)/$(GCC)/gcc/configure
	@mkdir -p $(DIR_WORKING)/$(GCC)/gcc-build
	@cd $(DIR_WORKING)/$(GCC)/gcc-build; ../configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/rootfs/var \
	    --libdir=$(DIR_DIST)/lib64 \
	    --with-build-sysroot=$(DIR_DIST)/rootfs \
	    --with-newlib \
	    --without-headers \
	    --with-local-prefix=$(DIR_DIST)/rootfs/usr \
	    --with-native-system-header-dir=$(DIR_DIST)/rootfs/usr/include \
	    --with-cloog=$(DIR_WORKING)/$(GCC)/cloog \
	    --with-isl=$(DIR_WORKING)/$(GCC)/$(ISL) \
	    --enable-languages=c,c++ \
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
	    --disable-multilib \
	    --disable-isl-version-check \
	    --disable-cloog-version-check \
	    --disable-libquadmath \
	    --disable-libquadmath-support \
	    --disable-libstdcxx \
	    && make && make install
	$(making-end)

kernel-headers:
	$(making-start)
	@cd $(DIR_3RD_PARTY); tar Jxf linux-$(KERNEL_VERSION).tar.xz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/linux-$(KERNEL_VERSION)/; \
	    make headers_check && \
	    make INSTALL_HDR_PATH=$(DIR_DIST)/rootfs/usr ARCH=x86 headers_install
	@rm -rf $(DIR_WORKING)/linux-$(KERNEL_VERSION)
	$(making-end)

glibc:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GLIBC).tar.xz -C $(DIR_WORKING)
	@mkdir -p $(DIR_WORKING)/$(GLIBC)/glibc_build
	@cd $(DIR_WORKING)/$(GLIBC)/glibc_build; \
	    ../configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/rootfs/var \
	    --libdir=$(DIR_DIST)/rootfs/usr/lib64 \
	    --enable-stackguard-randomization \
	    --enable-add-ons=nptl \
	    --with-headers=$(DIR_DIST)/rootfs/usr/include \
	    --enable-kernel=$(KERNEL_VERSION) \
	    --disable-nls \
	    libc_cv_forced_unwind=yes \
	    libc_cv_c_cleanup=yes \
	    libc_cv_ctors_header=yes \
	    libc_cv_ld_no_whole_archive=yes \
	    && make && make install
	$(making-end)

libstdc-plus-plus:
	$(making-start)
	@mkdir -p $(DIR_WORKING)/$(GCC)/libc++-build
	@cd $(DIR_WORKING)/$(GCC)/libc++-build; \
	    export PATH=$(DIR_DIST)/rootfs/usr/bin:$$PATH; \
	    ../libstdc++-v3/configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/rootfs/var \
	    --libdir=$(DIR_DIST)/rootfs/usr/lib64 \
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
	    CC=$(DIR_DIST)/rootfs/usr/bin/gcc \
	    ./configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
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
	    && make install
	#@cp /lib64/libdl.so.2 $(DIR_DIST)/rootfs/lib64/
	#@cp /lib64/libc.so.6 $(DIR_DIST)/rootfs/lib64/
	#@cp /lib64/ld-linux-x86-64.so.2 $(DIR_DIST)/rootfs/lib64/
	#@cp /lib64/libtinfo.so.5 $(DIR_DIST)/rootfs/lib64/
	$(making-end)

clean: toolchain_clean
	@rm -f $(PKGS)
	@rm -f *.making

.PHONY: all clean
