include ../common.mk

BINUTILS := binutils-2.24.51
GCC := gcc-4.8.2
MPFR := mpfr-3.1.2
GMP := gmp-5.1.3
MPC := mpc-1.0.1
GLIBC_LIBIDN := glibc-libidn-2.10.1
GLIBC := glibc-2.18

LINUXTHREAD := glibc-linuxthreads-2.5

BASH := bash-4.2

GRUB_VERSION := 2.00

PKGS += $(BINUTILS)
PKGS += $(GLIBC)
PKGS += $(BASH)

all:
	@cp init $(DIR_DIST)/rootfs/
	@chmod 775 $(DIR_DIST)/rootfs/init
	@for pkg in $(PKGS); do \
	    $(MAKE) $$pkg || exit 1; \
	done

$(BINUTILS):
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(BINUTILS).tar.bz2 -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(BINUTILS); ./configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/rootfs/var \
	    --libdir=$(DIR_DIST)/rootfs/lib64 \
	    --target=x86_64-VimOS-linux-gnu \
	    --with-build-sysroot=$(DIR_DIST)/rootfs \
	    --disable-nls \
	    && make && make install
	$(making-end)

$(GCC): $(BINUTILS)
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@tar Jxf $(DIR_3RD_PARTY)/$(MPFR).tar.xz -C $(DIR_WORKING)/$(GCC)
	@mv $(DIR_WORKING)/$(GCC)/$(MPFR) $(DIR_WORKING)/$(GCC)/mpfr
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)/$(GCC)
	@mv $(DIR_WORKING)/$(GCC)/$(GMP) $(DIR_WORKING)/$(GCC)/gmp
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -c $(DIR_WORKING)/$(GCC)
	@mv $(DIR_WORKING)/$(GCC)/$(MPC) $(DIR_WORKING)/$(GCC)/mpc
	@mkdir -p $(DIR_WORKING)/$(GCC)/gcc-build
	@cd $(DIR_WORKING)/$(GCC)/gcc-build; ./configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/rootfs/var \
	    --libdir=$(DIR_DIST)/rootfs/lib64 \
	    --target=x86_64-VimOS-linux-gnu \
	    --with-build-sysroot=$(DIR_DIST)/rootfs \
	    --with-newlib \
	    --without-headers \
	    --with-local-prefix=$(DIR_DIST)/rootfs/usr \
	    --with-native-system-header-dir=$(DIR_DIST)/rootfs/usr/include \
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
	    --disable-libstdc++-v3 \
	    --disable-multilib \
	    --enable-languages=c,c++ \
	    --disable-nls \
	    && make && make install
	$(making-end)


$(GLIBC): $(BINUTILS)
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GLIBC).tar.xz -C $(DIR_WORKING)
	@mkdir -p $(DIR_WORKING)/$(GLIBC)/tmp_build
	@tar jxf $(DIR_3RD_PARTY)/$(LINUXTHREAD).tar.bz2 -C $(DIR_WORKING)/$(GLIBC)
	@cd $(DIR_WORKING)/$(GLIBC)/tmp_build; ../configure \
	    --prefix=$(DIR_DIST)/rootfs/usr \
	    --sysconfdir=$(DIR_DIST)/rootfs/etc \
	    --localstatedir=$(DIR_DIST)/rootfs/var \
	    --libdir=$(DIR_DIST)/rootfs/lib64 \
	    --enable-stackguard-randomization \
	    --enable-add-ons=nptl \
	    --with-headers=$(DIR_DIST)/rootfs/usr/include \
	    --enable-kernel=$(KERNEL_VERSION) \
	    --enable-all-warnings \
	    --with-binutils=$(DIR_DIST)/rootfs/usr/bin \
	    --disable-nls \
	    && make all && make install
	$(making-end)

$(BASH): $(GLIBC)
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(BASH).tar.gz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(BASH); ./configure \
	    --prefix=$(DIR_DIST)/rootfs \
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
	$(making-end)

clean:
	@rm -f $(PKGS)
	@rm -f *.making

.PHONY: all clean
