include toolchain_common.mk

toolchain:
	make binutils
	make kernel_header
	make glibc
	make isl cloog
	make gcc

toolchain_clean:
	rm -f binutils
	rm -f kernel_header
	rm -f glibc
	rm -f isl cloog gcc

binutils:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(BINUTILS).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(BINUTILS) $(DIR_WORKING)/$@
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		--host=$(CROSS_COMPILE_TARGET) \
		$(INSTALL_DIRS) \
		--with-sysroot \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
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
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
		--with-headers=$(ROOTFS_PREFIX)/include \
		--disable-profile \
		--enable-kernel=2.6.32
	@cd $(DIR_WORKING)/$@/$@_build; \
		cp -v config.make{,.fake}; \
		cp -v config.status{,.fake};
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(FAKE_INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
		--with-headers=$(ROOTFS_PREFIX)/include \
		--disable-profile \
		--enable-kernel=2.6.32
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		fake_mtime=`stat config.make | grep 'Modify:' | cut -d' ' -f2-`; \
		mv -v config.make.fake config.make; \
		touch -d "$$fake_mtime" config.make; \
		fake_mtime=`stat config.status | grep 'Modify:' | cut -d' ' -f2-`; \
		mv -v config.status.fake config.status; \
		touch -d "$$fake_mtime" config.status;
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	@cp -v $(ROOTFS_PREFIX)/lib64/libc.so{,.orig}
	@cp -v $(ROOTFS_PREFIX)/lib64/libpthread.so{,.orig}
	@sed -i 's@$(ROOTFS)@@g' $(ROOTFS_PREFIX)/lib64/libc.so
	@sed -i 's@$(ROOTFS)@@g' $(ROOTFS_PREFIX)/lib64/libpthread.so
	@cp -v $(ROOTFS_PREFIX)/lib64/libc.so{,.new}
	@cp -v $(ROOTFS_PREFIX)/lib64/libpthread.so{,.new}
	$(making-end)

isl:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(ISL).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(ISL) $(DIR_WORKING)/$@
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(GMP) $(DIR_WORKING)/$@/gmp
	@cd $(DIR_WORKING)/$@/gmp; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		./configure \
		$(INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
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
		$(INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
		--with-gmp=build \
		--with-gmp-builddir=$(DIR_WORKING)/$@/gmp \
		--enable-static \
		--disable-shared \
		--disable-silent-rules \
		--disable-dependency-tracking \
		--enable-fast-install \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)

cloog:
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(CLOOG).tar.gz -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(CLOOG) $(DIR_WORKING)/$@
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(GMP) $(DIR_WORKING)/$@/gmp
	@cd $(DIR_WORKING)/$@/gmp; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		./configure \
		$(INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
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
		$(INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
		--enable-static \
		--disable-shared \
		--disable-silent-rules \
		--disable-dependency-tracking \
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

gcc:
	$(making-start)
	@tar jxf $(DIR_3RD_PARTY)/$(GCC).tar.bz2 -C $(DIR_WORKING)
	@mv -v $(DIR_WORKING)/$(GCC) $(DIR_WORKING)/$@
	@tar Jxf $(DIR_3RD_PARTY)/$(GMP).tar.xz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(GMP) $(DIR_WORKING)/$@/gmp
	@tar Jxf $(DIR_3RD_PARTY)/$(MPFR).tar.xz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(MPFR) $(DIR_WORKING)/$@/mpfr
	@tar zxf $(DIR_3RD_PARTY)/$(MPC).tar.gz -C $(DIR_WORKING)/$@
	@mv -v $(DIR_WORKING)/$@/$(MPC) $(DIR_WORKING)/$@/mpc
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@; \
		cat gcc/limitx.h gcc/glimits.h gcc/limity.h > $(shell dirname $(shell $(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc -print-libgcc-file-name))/include-fixed/limits.h
	@cd $(DIR_WORKING)/$@/$@_build; \
		CC_FOR_TARGET=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc \
		CXX_FOR_TARGET=$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-g++ \
		AR_FOR_TARGET=$(ROOTFS_PREFIX)/bin/ar \
		AS_FOR_TARGET=$(ROOTFS_PREFIX)/bin/as \
		LD_FOR_TARGET=$(ROOTFS_PREFIX)/bin/ld \
		NM_FOR_TARGET=$(ROOTFS_PREFIX)/bin/nm \
		RANLIB_FOR_TARGET=$(ROOTFS_PREFIX)/bin/ranlib \
		STRIP_FOR_TARGET=$(ROOTFS_PREFIX)/bin/strip \
		OBJCOPY_FOR_TARGET=$(ROOTFS_PREFIX)/bin/objcopy \
		OBJDUMP_FOR_TARGET=$(ROOTFS_PREFIX)/bin/objdump \
		READELF_FOR_TARGET=$(ROOTFS_PREFIX)/bin/readelf \
		../configure \
		$(INSTALL_DIRS) \
		--with-build-sysroot=$(ROOTFS) \
		--with-cloog=$(ROOTFS_PREFIX) \
		--enable-shared \
		--enable-threads=posix \
		--enable-__cxa_atexit \
		--enable-clocale=gnu \
		--enable-languages=c,c++ \
		--disable-multilib \
		--disable-bootstrap \
		--disable-lto \
		--disable-install-libiberty
	@cd $(DIR_WORKING)/$@/$@_build; \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		make install
	$(making-end)
