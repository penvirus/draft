include ../common.mk

ROOTFS := $(DIR_DIST)/rootfs
ROOTFS_PREFIX := $(DIR_DIST)/rootfs/usr

INSTALL_DIRS := \
    --prefix=$(ROOTFS_PREFIX) \
    --libdir=$(ROOTFS_PREFIX)/lib64 \
    --sysconfdir=$(ROOTFS)/etc \
    --localstatedir=$(ROOTFS)/var

BINUTILS := binutils-2.24.51
GMP := gmp-5.1.3
MPFR := mpfr-3.1.2
MPC := mpc-1.0.1
ISL := isl-0.11.1
CLOOG := cloog-0.18.0
GCC := gcc-4.8.2
GLIBC := glibc-2.18

BASH := bash-4.2
COREUTIL := coreutils-8.21

GRUB_VERSION := 2.00


PKGS += $(BASH)
PKGS += $(COREUTIL)

all: toolchain all_packages

TOOLCHAIN := binutils gmp mpfr mpc isl cloog gcc

toolchain:
	make $(addsuffix _pass1, $(TOOLCHAIN))
	make kernel_header
	make glibc
	make libstdc_plus_plus
	make $(addsuffix _pass2, $(TOOLCHAIN))

toolchain_clean:
	rm -f $(addsuffix _pass1, $(TOOLCHAIN))
	rm -f kernel_header
	rm -f glibc
	rm -f libstdc_plus_plus
	rm -f $(addsuffix _pass2, $(TOOLCHAIN))

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
	    --with-lib-path=$(ROOTFS_PREFIX)/lib64 \
	    --disable-nls \
	    --disable-werror
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make install
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
	    --enable-static \
	    --enable-fast-install \
	    --disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make install
	$(making-end)

mpfr_pass1:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(MPFR).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPFR) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --enable-fast-install \
	    --disable-nls \
	    --with-gmp-include=$(ROOTFS_PREFIX)/include \
	    --with-gmp-lib=$(ROOTFS_PREFIX)/lib64
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make install
	$(making-end)

mpc_pass1:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --enable-fast-install \
	    --disable-nls \
	    --with-gmp-include=$(ROOTFS_PREFIX)/include \
	    --with-gmp-lib=$(ROOTFS_PREFIX)/lib64 \
	    --with-mpfr-include=$(ROOTFS_PREFIX)/include \
	    --with-mpfr-lib=$(ROOTFS_PREFIX)/lib64
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make install
	$(making-end)

isl_pass1:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(ISL) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --disable-silent-rules \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --enable-fast-install \
	    --disable-nls \
	    --with-gmp-prefix=$(ROOTFS_PREFIX)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make install
	$(making-end)

cloog_pass1:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(CLOOG) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --disable-silent-rules \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --enable-fast-install \
	    --disable-nls \
	    --with-isl-prefix=$(ROOTFS_PREFIX) \
	    --with-gmp-prefix=$(ROOTFS_PREFIX)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make install
	$(making-end)

gcc_pass1:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GCC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cp -v replace_ld.sh $(DIR_WORKING)/$@/
	@cd $(DIR_WORKING)/$@; sh replace_ld.sh $(ROOTFS)
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
	    --enable-languages=c,c++
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make install
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
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --enable-stackguard-randomization \
	    --with-headers=$(ROOTFS_PREFIX)/include \
	    --disable-profile \
	    --enable-kernel=2.6.32 \
	    --disable-nls \
	    libc_cv_forced_unwind=yes \
	    libc_cv_c_cleanup=yes \
	    libc_cv_ctors_header=yes
	@cd $(DIR_WORKING)/$@/$@_build; \
	    cp -v config.status{,.wanted}; \
	    cp -v config.make{,.wanted}; \
	    cp -v Makefile{,.wanted}
	#@cd $(DIR_WORKING)/$@/$@_build; \
	#    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	#    ../configure \
	#    --prefix=/usr \
	#    --libdir=/usr/lib64 \
	#    --sysconfdir=/etc \
	#    --localstatedir=/var \
	#    --host=$(CROSS_COMPILE_TARGET) \
	#    --enable-stackguard-randomization \
	#    --with-headers=$(ROOTFS_PREFIX)/include \
	#    --disable-profile \
	#    --enable-kernel=2.6.32 \
	#    --disable-nls \
	#    libc_cv_forced_unwind=yes \
	#    libc_cv_c_cleanup=yes \
	#    libc_cv_ctors_header=yes
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make $(MAKE_FLAGS)
	#@cd $(DIR_WORKING)/$@/$@_build; \
	#    mv -v config.status.wanted config.status; \
	#    mv -v config.make.wanted config.make; \
	#    mv -v Makefile.wanted Makefile
	@cd $(DIR_WORKING)/$@/$@_build; \
	    make install
	cp -v $(ROOTFS_PREFIX)/lib64/libc.so{,.bak}
	cp -v $(ROOTFS_PREFIX)/lib64/libpthread.so{,.bak}
	sed -i 's@$(ROOTFS)@@g' $(ROOTFS_PREFIX)/lib64/libc.so
	sed -i 's@$(ROOTFS)@@g' $(ROOTFS_PREFIX)/lib64/libpthread.so
	$(making-end)

libstdc_plus_plus:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GCC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    ../libstdc++-v3/configure \
	    $(INSTALL_DIRS) \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --disable-multilib \
	    --disable-shared \
	    --disable-nls \
	    --disable-libstdcxx-threads \
	    --disable-libstdcxx-pch \
	    --with-gxx-include-dir=$(ROOTFS_PREFIX)/$(CROSS_COMPILE_TARGET)/include/c++/4.8.2
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make install
	$(making-end)

binutils_pass2:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(BINUTILS).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(BINUTILS) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --with-sysroot \
	    --with-build-sysroot=$(ROOTFS) \
	    --disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make install
	$(making-end)

gmp_pass2:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GMP) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --disable-shared \
	    --enable-static \
	    --enable-fast-install \
	    --disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make install
	$(making-end)

mpfr_pass2:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(MPFR).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPFR) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --enable-fast-install \
	    --disable-nls \
	    --with-gmp-include=$(ROOTFS_PREFIX)/include \
	    --with-gmp-lib=$(ROOTFS_PREFIX)/lib64
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make install
	$(making-end)

mpc_pass2:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --enable-fast-install \
	    --disable-nls \
	    --with-gmp-include=$(ROOTFS_PREFIX)/include \
	    --with-gmp-lib=$(ROOTFS_PREFIX)/lib64 \
	    --with-mpfr-include=$(ROOTFS_PREFIX)/include \
	    --with-mpfr-lib=$(ROOTFS_PREFIX)/lib64
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make install
	$(making-end)

isl_pass2:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(ISL) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --disable-silent-rules \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --enable-fast-install \
	    --disable-nls \
	    --with-gmp-prefix=$(ROOTFS_PREFIX)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make install
	$(making-end)

cloog_pass2:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(CLOOG) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    ../configure \
	    $(INSTALL_DIRS) \
	    --host=$(CROSS_COMPILE_TARGET) \
	    --disable-silent-rules \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --enable-fast-install \
	    --disable-nls \
	    --with-isl-prefix=$(ROOTFS_PREFIX) \
	    --with-gmp-prefix=$(ROOTFS_PREFIX)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
	    PATH=$(ROOTFS_PREFIX)/bin:$${PATH} \
	    make install
	$(making-end)

gcc_pass2:
	exit 1
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GCC) $(DIR_WORKING)/$@
	@cp -v replace_ld.sh $(DIR_WORKING)/$@/
	@cd $(DIR_WORKING)/$@; sh replace_ld.sh $(ROOTFS)
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
	@test -e $(ROOTFS_PREFIX)/bin/cc || ln -sv ./gcc $(ROOTFS_PREFIX)/bin/cc
	    #--with-build-sysroot=$(ROOTFS)
	    #--with-sysroot=$(ROOTFS)

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
