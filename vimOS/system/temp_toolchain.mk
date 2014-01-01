include toolchain_common.mk

TOOLCHAIN := binutils isl cloog gcc

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

.PHONY: temp_toolchain temp_toolchain_clean

TEMP_CROSS_COMPILE_TARGET := x86_64-temp1-linux-gnu

temp_binutils_pass1:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(BINUTILS).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(BINUTILS) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--target=$(TEMP_CROSS_COMPILE_TARGET) \
		--with-sysroot=$(TEMP_ROOTFS) \
		--with-lib-path=$(TEMP_ROOTFS_PREFIX)/lib64 \
		--disable-nls \
		--disable-werror
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)

temp_isl_pass1:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(ISL) $(DIR_WORKING)/$@
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(GMP) $(DIR_WORKING)/$@/gmp
	@cd $(DIR_WORKING)/$@/gmp; \
		./configure \
		$(TEMP_INSTALL_DIRS) \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls
	@cd $(DIR_WORKING)/$@/gmp; \
		make $(MAKE_FLAGS)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--with-gmp=build \
		--with-gmp-builddir=$(DIR_WORKING)/$@/gmp \
		--enable-static \
		--disable-shared \
		--disable-silent-rules \
		--disable-dependency-tracking \
		--enable-fast-install \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)

temp_cloog_pass1:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(CLOOG) $(DIR_WORKING)/$@
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(GMP) $(DIR_WORKING)/$@/gmp
	@cd $(DIR_WORKING)/$@/gmp; \
		./configure \
		$(TEMP_INSTALL_DIRS) \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls
	@cd $(DIR_WORKING)/$@/gmp; \
		make $(MAKE_FLAGS)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--enable-static \
		--disable-shared \
		--disable-silent-rules \
		--disable-dependency-tracking \
		--enable-fast-install \
		--with-gmp=build \
		--with-gmp-builddir=$(DIR_WORKING)/$@/gmp \
		--disable-nls
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
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(GMP) $(DIR_WORKING)/$@/gmp
	@tar Jxf $(DIR_3RD_PARTY)/$(MPFR).tar.xz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(MPFR) $(DIR_WORKING)/$@/mpfr
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(MPC) $(DIR_WORKING)/$@/mpc
	@cp -v replace_ld.sh $(DIR_WORKING)/$@/
	@cd $(DIR_WORKING)/$@; sh replace_ld.sh $(TEMP_ROOTFS)
	@sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' $(DIR_WORKING)/$@/gcc/configure
	@cd $(DIR_WORKING)/$@/$@_build; \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--target=$(TEMP_CROSS_COMPILE_TARGET) \
		--with-sysroot=$(TEMP_ROOTFS) \
		--with-local-prefix=$(TEMP_ROOTFS_PREFIX) \
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
		--host=$(TEMP_CROSS_COMPILE_TARGET) \
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
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	cp -v $(TEMP_ROOTFS_PREFIX)/lib64/libc.so{,.orig}
	cp -v $(TEMP_ROOTFS_PREFIX)/lib64/libpthread.so{,.orig}
	sed -i 's@$(TEMP_ROOTFS)@@g' $(TEMP_ROOTFS_PREFIX)/lib64/libc.so
	sed -i 's@$(TEMP_ROOTFS)@@g' $(TEMP_ROOTFS_PREFIX)/lib64/libpthread.so
	cp -v $(TEMP_ROOTFS_PREFIX)/lib64/libc.so{,.new}
	cp -v $(TEMP_ROOTFS_PREFIX)/lib64/libpthread.so{,.new}
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
		--host=$(TEMP_CROSS_COMPILE_TARGET) \
		--disable-multilib \
		--disable-shared \
		--disable-nls \
		--disable-libstdcxx-threads \
		--disable-libstdcxx-pch \
		--with-gxx-include-dir=$(TEMP_ROOTFS_PREFIX)/$(TEMP_CROSS_COMPILE_TARGET)/include/c++/4.8.2
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
		CC=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-gcc \
		CXX=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-g++ \
		AR=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-ar \
		AS=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-as \
		LD=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-ld \
		NM=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-nm \
		RANLIB=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-ranlib \
		STRIP=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-strip \
		OBJCOPY=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-objcopy \
		OBJDUMP=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-objdump \
		READELF=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-readelf \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--target=$(CROSS_COMPILE_TARGET) \
		--with-sysroot \
		--with-build-sysroot=$(TEMP_ROOTFS) \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	@cd $(DIR_WORKING)/$@/$@_build; \
		make -C ld clean;
	@cd $(DIR_WORKING)/$@/$@_build; \
		make -C ld LIB_PATH=$(TEMP_ROOTFS_PREFIX)/lib64; \
		cp -v ld/ld-new $(TEMP_ROOTFS_PREFIX)/bin/ld
	$(making-end)

temp_isl_pass2:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(ISL) $(DIR_WORKING)/$@
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(GMP) $(DIR_WORKING)/$@/gmp
	@cd $(DIR_WORKING)/$@/gmp; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		./configure \
		$(TEMP_INSTALL_DIRS) \
		--host=$(TEMP_CROSS_COMPILE_TARGET) \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls
	@cd $(DIR_WORKING)/$@/gmp; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--host=$(TEMP_CROSS_COMPILE_TARGET) \
		--with-gmp=build \
		--with-gmp-builddir=$(DIR_WORKING)/$@/gmp \
		--disable-silent-rules \
		--disable-dependency-tracking \
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

temp_cloog_pass2:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(CLOOG) $(DIR_WORKING)/$@
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(GMP) $(DIR_WORKING)/$@/gmp
	@cd $(DIR_WORKING)/$@/gmp; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		./configure \
		$(TEMP_INSTALL_DIRS) \
		--host=$(TEMP_CROSS_COMPILE_TARGET) \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--disable-nls
	@cd $(DIR_WORKING)/$@/gmp; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--host=$(TEMP_CROSS_COMPILE_TARGET) \
		--disable-silent-rules \
		--disable-dependency-tracking \
		--disable-shared \
		--enable-static \
		--enable-fast-install \
		--with-gmp=build \
		--with-gmp-builddir=$(DIR_WORKING)/$@/gmp \
		--disable-nls
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
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(GMP) $(DIR_WORKING)/$@/gmp
	@tar Jxf $(DIR_3RD_PARTY)/$(MPFR).tar.xz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(MPFR) $(DIR_WORKING)/$@/mpfr
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(MPC) $(DIR_WORKING)/$@/mpc
	@cp -v replace_ld.sh $(DIR_WORKING)/$@/
	#@cd $(DIR_WORKING)/$@; sh replace_ld.sh $(TEMP_ROOTFS)
	@cd $(DIR_WORKING)/$@; \
		cat gcc/limitx.h gcc/glimits.h gcc/limity.h > $(shell dirname $(shell $(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-gcc -print-libgcc-file-name))/include-fixed/limits.h
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		CC=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-gcc \
		CXX=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-g++ \
		AR=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-ar \
		AS=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-as \
		LD=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-ld \
		NM=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-nm \
		RANLIB=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-ranlib \
		STRIP=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-strip \
		OBJCOPY=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-objcopy \
		OBJDUMP=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-objdump \
		READELF=$(TEMP_ROOTFS_PREFIX)/bin/$(TEMP_CROSS_COMPILE_TARGET)-readelf \
		../configure \
		$(TEMP_INSTALL_DIRS) \
		--target=$(CROSS_COMPILE_TARGET) \
		--with-build-sysroot=$(TEMP_ROOTFS) \
		--with-sysroot=$(TEMP_ROOTFS) \
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
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	@test -e $(TEMP_ROOTFS_PREFIX)/bin/cc || ln -sv ./$(CROSS_COMPILE_TARGET)-gcc $(TEMP_ROOTFS_PREFIX)/bin/cc
	$(making-end)
