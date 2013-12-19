BINUTILS := binutils-2.24.51
GMP := gmp-5.1.3
MPFR := mpfr-3.1.2
MPC := mpc-1.0.1
ISL := isl-0.11.1
CLOOG := cloog-0.18.0
GCC := gcc-4.8.2
GLIBC := glibc-2.18

TOOLCHAIN := binutils gmp mpfr mpc isl cloog gcc

toolchain:
	make binutils
	make kernel_header
	make glibc
	make gmp mpfr mpc isl cloog gcc

toolchain_clean:
	rm -f $(TOOLCHAIN)
	rm -f kernel_header

binutils:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(BINUTILS).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(BINUTILS) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(INSTALL_DIRS) \
		--with-sysroot \
		--disable-nls
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
		CC=$(TEMP_ROOTFS_PREFIX)/bin/gcc \
		CXX=$(TEMP_ROOTFS_PREFIX)/bin/g++ \
		AR=$(TEMP_ROOTFS_PREFIX)/bin/ar \
		AS=$(TEMP_ROOTFS_PREFIX)/bin/as \
		LD=$(TEMP_ROOTFS_PREFIX)/bin/ld \
		NM=$(TEMP_ROOTFS_PREFIX)/bin/nm \
		RANLIB=$(TEMP_ROOTFS_PREFIX)/bin/ranlib \
		STRIP=$(TEMP_ROOTFS_PREFIX)/bin/strip \
		OBJCOPY=$(TEMP_ROOTFS_PREFIX)/bin/objcopy \
		OBJDUMP=$(TEMP_ROOTFS_PREFIX)/bin/objdump \
		READELF=$(TEMP_ROOTFS_PREFIX)/bin/readelf \
		../configure \
		$(INSTALL_DIRS) \
		--enable-stackguard-randomization \
		--with-headers=$(ROOTFS_PREFIX)/include \
		--disable-profile \
		--enable-kernel=2.6.32 \
		--disable-nls \
		libc_cv_forced_unwind=yes \
		libc_cv_c_cleanup=yes \
		libc_cv_ctors_header=yes
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	sed -i 's@$(ROOTFS)@@g' $(ROOTFS_PREFIX)/lib64/libc.so
	sed -i 's@$(ROOTFS)@@g' $(ROOTFS_PREFIX)/lib64/libpthread.so
	$(making-end)

gmp:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GMP) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		CC=$(TEMP_ROOTFS_PREFIX)/bin/gcc \
		CXX=$(TEMP_ROOTFS_PREFIX)/bin/g++ \
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

mpfr:
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

mpc:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		CC=$(TEMP_ROOTFS_PREFIX)/bin/gcc \
		CXX=$(TEMP_ROOTFS_PREFIX)/bin/g++ \
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

isl:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(ISL) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		CC=$(TEMP_ROOTFS_PREFIX)/bin/gcc \
		CXX=$(TEMP_ROOTFS_PREFIX)/bin/g++ \
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

cloog:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(CLOOG) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		CC=$(TEMP_ROOTFS_PREFIX)/bin/gcc \
		CXX=$(TEMP_ROOTFS_PREFIX)/bin/g++ \
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

gcc:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GCC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	#@sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' $(DIR_WORKING)/$@/gcc/configure
	@cd $(DIR_WORKING)/$@/$@_build; \
		CC=$(TEMP_ROOTFS_PREFIX)/bin/gcc \
		CXX=$(TEMP_ROOTFS_PREFIX)/bin/g++ \
		AR=$(TEMP_ROOTFS_PREFIX)/bin/ar \
		AS=$(TEMP_ROOTFS_PREFIX)/bin/as \
		LD=$(TEMP_ROOTFS_PREFIX)/bin/ld \
		NM=$(TEMP_ROOTFS_PREFIX)/bin/nm \
		RANLIB=$(TEMP_ROOTFS_PREFIX)/bin/ranlib \
		STRIP=$(TEMP_ROOTFS_PREFIX)/bin/strip \
		OBJCOPY=$(TEMP_ROOTFS_PREFIX)/bin/objcopy \
		OBJDUMP=$(TEMP_ROOTFS_PREFIX)/bin/objdump \
		READELF=$(TEMP_ROOTFS_PREFIX)/bin/readelf \
		../configure \
		$(INSTALL_DIRS) \
		--with-build-sysroot=$(ROOTFS) \
		--with-gmp=$(ROOTFS_PREFIX) \
		--with-mpfr=$(ROOTFS_PREFIX) \
		--with-mpc=$(ROOTFS_PREFIX) \
		--with-isl=$(ROOTFS_PREFIX) \
		--with-cloog=$(ROOTFS_PREFIX) \
		--with-newlib \
		--enable-shared \
		--enable-threads=posix \
		--enable-__cxa_atexit \
		--enable-clocale=gnu \
		--enable-languages=c,c++ \
		--disable-multilib \
		--disable-bootstrap \
		--disable-install-libiberty
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)
	exit 1
		#--with-system-zlib

temp_toolchain:
	make $(addsuffix _pass1, $(addprefix temp_, $(TOOLCHAIN)))
	make temp_kernel_header
	make temp_glibc
	make temp_libstdc_plus_plus
	make $(addsuffix _pass2, $(addprefix temp_, $(TOOLCHAIN)))

temp_toolchain_clean:
	rm -f $(addsuffix _pass1, $(addprefix temp_, $(TOOLCHAIN)))
	rm -f temp_kernel_header
	rm -f temp_glibc
	rm -f temp_libstdc_plus_plus
	rm -f $(addsuffix _pass2, $(addprefix temp_, $(TOOLCHAIN)))

temp_binutils_pass1:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(BINUTILS).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(BINUTILS) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--target=$(CROSS_COMPILE_TARGET) \
		--with-sysroot=$(TEMP_ROOTFS) \
		--with-lib-path=$(TEMP_ROOTFS_PREFIX)/lib64 \
		--disable-nls \
		--disable-werror
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)

temp_gmp_pass1:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GMP) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)

temp_mpfr_pass1:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(MPFR).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPFR) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls \
		--with-gmp-include=$(TEMP_ROOTFS_PREFIX)/include \
		--with-gmp-lib=$(TEMP_ROOTFS_PREFIX)/lib64
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)

temp_mpc_pass1:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls \
		--with-gmp-include=$(TEMP_ROOTFS_PREFIX)/include \
		--with-gmp-lib=$(TEMP_ROOTFS_PREFIX)/lib64 \
		--with-mpfr-include=$(TEMP_ROOTFS_PREFIX)/include \
		--with-mpfr-lib=$(TEMP_ROOTFS_PREFIX)/lib64
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)

temp_isl_pass1:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(ISL) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--disable-silent-rules \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls \
		--with-gmp-prefix=$(TEMP_ROOTFS_PREFIX)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)

temp_cloog_pass1:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(CLOOG) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--disable-silent-rules \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls \
		--with-isl-prefix=$(TEMP_ROOTFS_PREFIX) \
		--with-gmp-prefix=$(TEMP_ROOTFS_PREFIX)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)

temp_gcc_pass1:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GCC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cp -v replace_ld.sh $(DIR_WORKING)/$@/
	@cd $(DIR_WORKING)/$@; sh replace_ld.sh $(TEMP_ROOTFS)
	@sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' $(DIR_WORKING)/$@/gcc/configure
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--target=$(CROSS_COMPILE_TARGET) \
		--with-local-prefix=$(TEMP_ROOTFS_PREFIX) \
		--with-sysroot=$(TEMP_ROOTFS) \
		--with-gmp=$(TEMP_ROOTFS_PREFIX) \
		--with-mpfr=$(TEMP_ROOTFS_PREFIX) \
		--with-mpc=$(TEMP_ROOTFS_PREFIX) \
		--with-isl=$(TEMP_ROOTFS_PREFIX) \
		--with-cloog=$(TEMP_ROOTFS_PREFIX) \
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

temp_kernel_header:
	$(making-start)
	@cd $(DIR_3RD_PARTY); tar Jxf linux-$(KERNEL_VERSION).tar.xz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/linux-$(KERNEL_VERSION)/; \
		make headers_check && \
		make INSTALL_HDR_PATH=$(TEMP_ROOTFS_PREFIX) ARCH=x86 headers_install
	$(making-end)

temp_glibc:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GLIBC).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GLIBC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
		--enable-stackguard-randomization \
		--with-headers=$(TEMP_ROOTFS_PREFIX)/include \
		--disable-profile \
		--enable-kernel=2.6.32 \
		--disable-nls \
		libc_cv_forced_unwind=yes \
		libc_cv_c_cleanup=yes \
		libc_cv_ctors_header=yes
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	cp -v $(TEMP_ROOTFS_PREFIX)/lib64/libc.so{,.bak}
	cp -v $(TEMP_ROOTFS_PREFIX)/lib64/libpthread.so{,.bak}
	sed -i 's@$(TEMP_ROOTFS)@@g' $(TEMP_ROOTFS_PREFIX)/lib64/libc.so
	sed -i 's@$(TEMP_ROOTFS)@@g' $(TEMP_ROOTFS_PREFIX)/lib64/libpthread.so
	$(making-end)

temp_libstdc_plus_plus:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GCC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../libstdc++-v3/configure \
		$(TEMP_INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
		--disable-multilib \
		--disable-shared \
		--disable-nls \
		--disable-libstdcxx-threads \
		--disable-libstdcxx-pch \
		--with-gxx-include-dir=$(TEMP_ROOTFS_PREFIX)/$(CROSS_COMPILE_TARGET)/include/c++/4.8.2
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)

temp_binutils_pass2:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(BINUTILS).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(BINUTILS) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		CC=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
		CXX=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
		AR=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-ar \
		AS=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-as \
		LD=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-ld \
		NM=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-nm \
		RANLIB=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-ranlib \
		STRIP=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-strip \
		OBJCOPY=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-objcopy \
		OBJDUMP=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-objdump \
		READELF=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-readelf \
		$(TEMP_INSTALL_DIRS) \
		--with-sysroot \
		--with-build-sysroot=$(TEMP_ROOTFS) \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)

temp_gmp_pass2:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GMP) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)

temp_mpfr_pass2:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(MPFR).tar.xz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPFR) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls \
		--with-gmp-include=$(TEMP_ROOTFS_PREFIX)/include \
		--with-gmp-lib=$(TEMP_ROOTFS_PREFIX)/lib64
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)

temp_mpc_pass2:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(MPC) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls \
		--with-gmp-include=$(TEMP_ROOTFS_PREFIX)/include \
		--with-gmp-lib=$(TEMP_ROOTFS_PREFIX)/lib64 \
		--with-mpfr-include=$(TEMP_ROOTFS_PREFIX)/include \
		--with-mpfr-lib=$(TEMP_ROOTFS_PREFIX)/lib64
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)

temp_isl_pass2:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(ISL) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
		--disable-silent-rules \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls \
		--with-gmp-prefix=$(TEMP_ROOTFS_PREFIX)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)

temp_cloog_pass2:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(CLOOG) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
		--disable-silent-rules \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls \
		--with-isl-prefix=$(TEMP_ROOTFS_PREFIX) \
		--with-gmp-prefix=$(TEMP_ROOTFS_PREFIX)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)

temp_gcc_pass2:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GCC) $(DIR_WORKING)/$@
	@cp -v replace_ld.sh $(DIR_WORKING)/$@/
	@cd $(DIR_WORKING)/$@; sh replace_ld.sh $(TEMP_ROOTFS)
	@cd $(DIR_WORKING)/$@; \
		cat gcc/limitx.h gcc/glimits.h gcc/limity.h > $(shell dirname $(shell $(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc -print-libgcc-file-name))/include-fixed/limits.h
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		CC=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
		CXX=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
		AR=$(TEMP_ROOTFS_PREFIX)/bin/ar \
		AS=$(TEMP_ROOTFS_PREFIX)/bin/as \
		LD=$(TEMP_ROOTFS_PREFIX)/bin/ld \
		NM=$(TEMP_ROOTFS_PREFIX)/bin/nm \
		RANLIB=$(TEMP_ROOTFS_PREFIX)/bin/ranlib \
		STRIP=$(TEMP_ROOTFS_PREFIX)/bin/strip \
		OBJCOPY=$(TEMP_ROOTFS_PREFIX)/bin/objcopy \
		OBJDUMP=$(TEMP_ROOTFS_PREFIX)/bin/objdump \
		READELF=$(TEMP_ROOTFS_PREFIX)/bin/readelf \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--with-build-sysroot=$(TEMP_ROOTFS) \
		--with-sysroot=$(TEMP_ROOTFS) \
		--with-gmp=$(TEMP_ROOTFS_PREFIX) \
		--with-mpfr=$(TEMP_ROOTFS_PREFIX) \
		--with-mpc=$(TEMP_ROOTFS_PREFIX) \
		--with-isl=$(TEMP_ROOTFS_PREFIX) \
		--with-cloog=$(TEMP_ROOTFS_PREFIX) \
		--enable-clocale=gnu \
		--enable-shared \
		--enable-threads=posix \
		--enable-__cxa_atexit \
		--enable-languages=c,c++ \
		--disable-libstdcxx-pch \
		--disable-multilib \
		--disable-bootstrap \
		--disable-libgomp
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	@test -e $(TEMP_ROOTFS_PREFIX)/bin/cc || ln -sv ./gcc $(TEMP_ROOTFS_PREFIX)/bin/cc
	$(making-end)
