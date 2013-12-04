include ../common.mk

ROOTFS := $(DIR_DIST)/rootfs
ROOTFS_PREFIX := $(DIR_DIST)/rootfs/usr
ROOTFS_LIB := $(DIR_DIST)/rootfs/usr/lib64
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
COREUTIL := coreutils-8.21

GRUB_VERSION := 2.00

INSTALL_DIRS := \
    --prefix=$(ROOTFS_PREFIX) \
    --libdir=$(ROOTFS_LIB) \
    --sysconfdir=$(ROOTFS_ETC) \
    --localstatedir=$(ROOTFS_VAR)

PKGS += $(BASH)
PKGS += $(COREUTIL)

all: toolchain all_packages

TOOLCHAIN := binutils gmp mpfr mpc isl cloog gcc

toolchain:
	mkdir -pv $(ROOTFS_LIB)
	test -e $(ROOTFS)/usr/lib || ln -sv $(ROOTFS_LIB) $(ROOTFS)/usr/lib
	test -e $(ROOTFS)/lib || ln -sv $(ROOTFS_LIB) $(ROOTFS)/lib
	test -e $(ROOTFS)/usr/lib64 || ln -sv $(ROOTFS_LIB) $(ROOTFS)/usr/lib64
	test -e $(ROOTFS)/lib64 || ln -sv $(ROOTFS_LIB) $(ROOTFS)/lib64
	make $(addsuffix _pass1, $(TOOLCHAIN))
	make kernel_header
	make glibc
	make libstdc_plus_plus
	make $(addsuffix _pass2, $(TOOLCHAIN))
	exit 1

toolchain_clean:
	rm -f $(addsuffix _pass1, $(TOOLCHAIN))
	rm -f $(addsuffix _pass2, $(TOOLCHAIN))
	rm -f glibc
	rm -f kernel_header
	rm -f libstdc_plus_plus
	rm -f binutils
	rm -f compiler

binutils_pass1:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(BINUTILS).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(BINUTILS) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --target=$(CROSS_COMPILE_TARGET) \
	    --with-sysroot=$(ROOTFS) \
	    --with-lib-path=$(ROOTFS_LIB) \
	    --disable-nls \
	    --disable-werror \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

gmp_pass1:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GMP) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --disable-shared \
	    --enable-fast-install \
	    --disable-nls \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

mpfr_pass1:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(MPFR).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPFR) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --disable-shared \
	    --disable-dependency-tracking \
	    --disable-nls \
	    --with-gmp-include=$(ROOTFS_PREFIX)/include \
	    --with-gmp-lib=$(ROOTFS_PREFIX)/lib64 \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

mpc_pass1:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --disable-shared \
	    --disable-dependency-tracking \
	    --disable-nls \
	    --with-gmp-include=$(ROOTFS_PREFIX)/include \
	    --with-gmp-lib=$(ROOTFS_PREFIX)/lib64 \
	    --with-mpfr-include=$(ROOTFS_PREFIX)/include \
	    --with-mpfr-lib=$(ROOTFS_PREFIX)/lib64 \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

isl_pass1:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(ISL) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --enable-silent-rules \
	    --disable-shared \
	    --disable-dependency-tracking \
	    --disable-nls \
	    --with-gmp-prefix=$(ROOTFS_PREFIX) \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

cloog_pass1:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(CLOOG) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --enable-silent-rules \
	    --disable-shared \
	    --disable-dependency-tracking \
	    --disable-nls \
	    --enable-fast-install \
	    --with-isl-prefix=$(ROOTFS_PREFIX) \
	    --with-gmp-prefix=$(ROOTFS_PREFIX) \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

gcc_pass1:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GCC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cp -v replace_ld.sh $(DIR_WORKING)/$@/
	@cd $(DIR_WORKING)/$@; sh replace_ld.sh $(DIR_DIST)/rootfs
	@sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' $(DIR_WORKING)/$@/gcc/configure
	@cd $(DIR_WORKING)/$@/$@_build; \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --target=$(CROSS_COMPILE_TARGET) \
	    --with-local-prefix=$(ROOTFS_PREFIX) \
	    --with-sysroot=$(ROOTFS) \
	    --with-gmp=$(ROOTFS_PREFIX) \
	    --with-mpfr=$(ROOTFS_PREFIX) \
	    --with-mpc=$(ROOTFS_PREFIX) \
	    --with-isl=$(ROOTFS_PREFIX) \
	    --with-cloog=$(ROOTFS_PREFIX) \
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
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

kernel_header:
	$(making-start)
	@cd $(DIR_3RD_PARTY); tar Jxf linux-$(KERNEL_VERSION).tar.xz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/linux-$(KERNEL_VERSION)/; \
	    make headers_check && \
	    make INSTALL_HDR_PATH=$(ROOTFS_PREFIX) ARCH=x86 headers_install
	$(making-end)

glibc:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GLIBC).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GLIBC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    CC=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    CXX=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --enable-stackguard-randomization \
	    --with-headers=$(ROOTFS_PREFIX)/include \
	    --enable-kernel=2.6.32 \
	    --disable-nls \
	    libc_cv_forced_unwind=yes \
	    libc_cv_c_cleanup=yes \
	    libc_cv_ctors_header=yes \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)
	cp -v $(ROOTFS_LIB)/libc.so $(ROOTFS_LIB)/libc.so.new
	cp -v $(ROOTFS_LIB)/libpthread.so $(ROOTFS_LIB)/libpthread.so.new
	cp -v $(ROOTFS_LIB)/libc.so $(ROOTFS_LIB)/libc.so.old
	cp -v $(ROOTFS_LIB)/libpthread.so $(ROOTFS_LIB)/libpthread.so.old
	sed -i 's@$(ROOTFS)@@g' $(ROOTFS_LIB)/libc.so.new
	sed -i 's@$(ROOTFS)@@g' $(ROOTFS_LIB)/libpthread.so.new

libstdc_plus_plus:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GCC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    CC=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    CXX=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
	    ../libstdc++-v3/configure \
	    $(INSTALL_DIRS) \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --disable-multilib \
	    --disable-shared \
	    --disable-nls \
	    --disable-libstdcxx-threads \
	    --disable-libstdcxx-pch \
	    --with-gxx-include-dir=$(ROOTFS_PREFIX)/$(CROSS_COMPILE_TARGET)/include/c++/4.8.2 \
	    && make -j4 && make install
	$(making-end)

binutils_pass2:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(BINUTILS).tar.bz2 -C $(DIR_WORKING)
	@mkdir -pv $(DIR_WORKING)/$(BINUTILS)/binutils-build
	@cd $(DIR_WORKING)/$(BINUTILS)/binutils-build; \
	    CC=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    CXX=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
	    AR=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-ar \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --with-lib-path=$(ROOTFS_LIB) \
	    --with-sysroot \
	    --disable-nls \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

gmp_pass2:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GMP) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    CC=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    CXX=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
	    AR=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-ar \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --disable-shared \
	    --enable-fast-install \
	    --disable-nls \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

mpfr_pass2:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(MPFR).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPFR) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    CC=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    CXX=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
	    AR=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-ar \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --disable-shared \
	    --disable-dependency-tracking \
	    --disable-nls \
	    --with-gmp-include=$(ROOTFS_PREFIX)/include \
	    --with-gmp-lib=$(ROOTFS_PREFIX)/lib64 \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

mpc_pass2:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    CC=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    CXX=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
	    AR=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-ar \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --disable-shared \
	    --disable-dependency-tracking \
	    --disable-nls \
	    --with-gmp-include=$(ROOTFS_PREFIX)/include \
	    --with-gmp-lib=$(ROOTFS_PREFIX)/lib64 \
	    --with-mpfr-include=$(ROOTFS_PREFIX)/include \
	    --with-mpfr-lib=$(ROOTFS_PREFIX)/lib64 \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

isl_pass2:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(ISL) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    CC=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    CXX=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
	    AR=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-ar \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --enable-silent-rules \
	    --disable-shared \
	    --disable-dependency-tracking \
	    --disable-nls \
	    --with-gmp-prefix=$(ROOTFS_PREFIX) \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

cloog_pass2:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(CLOOG) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    CC=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    CXX=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
	    AR=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-ar \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --enable-silent-rules \
	    --disable-shared \
	    --disable-dependency-tracking \
	    --disable-nls \
	    --enable-fast-install \
	    --with-isl-prefix=$(ROOTFS_PREFIX) \
	    --with-gmp-prefix=$(ROOTFS_PREFIX) \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)

gcc_pass2:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GCC) $(DIR_WORKING)/$@
	@cp -v replace_ld.sh $(DIR_WORKING)/$@/
	@cd $(DIR_WORKING)/$@; sh replace_ld.sh $(DIR_DIST)/rootfs
	@cd $(DIR_WORKING)/$@; \
	    cat gcc/limitx.h gcc/glimits.h gcc/limity.h > $(shell dirname $(shell $(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc -print-libgcc-file-name))/include-fixed/limits.h
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    CC=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
	    CXX=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
	    AR=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-ar \
	    RANLIB=$(ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-ranlib \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --with-local-prefix=$(ROOTFS_PREFIX) \
	    --with-sysroot=$(ROOTFS) \
	    --with-gmp=$(ROOTFS_PREFIX) \
	    --with-mpfr=$(ROOTFS_PREFIX) \
	    --with-mpc=$(ROOTFS_PREFIX) \
	    --with-isl=$(ROOTFS_PREFIX) \
	    --with-cloog=$(ROOTFS_PREFIX) \
	    --enable-clocale=gnu \
	    --enable-shared \
	    --enable-threads=posix \
	    --enable-__cxa_atexit \
	    --enable-languages=c,c++ \
	    --disable-libstdcxx-pch \
	    --disable-multilib \
	    --disable-bootstrap \
	    --disable-libgomp \
	    && make $(MAKE_FLAGS) \
	    && make install
	$(making-end)
	    #--with-build-sysroot=$(ROOTFS)

all_packages:
	@install -m 775 init $(DIR_DIST)/rootfs/
	@for pkg in $(PKGS); do \
	    $(MAKE) $$pkg || exit 1; \
	done

$(BASH):
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(BASH).tar.gz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(BASH); \
	    CC=$(ROOTFS_PREFIX)/bin/gcc \
	    CXX=$(ROOTFS_PREFIX)/bin/g++ \
	    ./configure \
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
	    && make -j4 && make install
	$(making-end)

$(COREUTIL):
	$(making-start)
	@tar xJf $(DIR_3RD_PARTY)/$(COREUTIL).tar.xz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(COREUTIL); \
	    CC=$(ROOTFS_PREFIX)/bin/gcc \
	    CXX=$(ROOTFS_PREFIX)/bin/g++ \
	    ./configure \
	    $(INSTALL_DIRS) \
	    --enable-install-program=hostname \
	    --disable-nls \
	    && make -j4 && make install
	$(making-end)

clean: toolchain_clean
	@rm -f $(PKGS)
	@rm -f *.making

.PHONY: all clean
