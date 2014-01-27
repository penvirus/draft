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

packages:
	@install -m 775 init $(ROOTFS)
	@for pkg in $(PKGS); do \
		$(MAKE) $$pkg || exit 1; \
	done

packages_clean:
	@rm -f $(PKGS)

.PHONY: packages packages_clean

$(BASH):
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$@.tar.gz -C $(DIR_WORKING)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
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
		--build=x86_64-unknown-linux-gnu \
		--host=$(CROSS_COMPILE_TARGET) \
		--enable-install-program=hostname \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
	    sed -e 's/^#run_help2man\|^run_help2man/#&/' \
	      -e 's/^\##run_help2man/run_help2man/' -i Makefile
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)

$(STRACE):
	$(making-start)
	@tar xJf $(DIR_3RD_PARTY)/$(STRACE).tar.xz -C $(DIR_WORKING)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(INSTALL_DIRS) \
		--host=$(CROSS_COMPILE_TARGET) \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)

$(NCURSES):
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$@.tar.gz -C $(DIR_WORKING)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(INSTALL_DIRS) \
		--build=x86_64-unknown-linux-gnu \
		--host=$(CROSS_COMPILE_TARGET) \
		--with-shared \
		--without-debug \
		--with-termlib \
		--with-ticlib \
		--enable-widec \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		../configure \
		$(INSTALL_DIRS) \
		--build=x86_64-unknown-linux-gnu \
		--host=$(CROSS_COMPILE_TARGET) \
		--with-shared \
		--without-debug \
		--with-termlib \
		--with-ticlib \
		--disable-nls
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@/$@_build; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)

$(LESS):
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$@.tar.gz -C $(DIR_WORKING)
	@mkdir -pv $(DIR_WORKING)/$@/$@_build
	@cd $(DIR_WORKING)/$@/$@_build; \
		CC="$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc --sysroot=$(ROOTFS)" \
		../configure \
		$(INSTALL_DIRS) \
		--build=x86_64-unknown-linux-gnu \
		--host=$(CROSS_COMPILE_TARGET) \
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
		CC="$(TEMP_ROOTFS_PREFIX)/bin/$(CROSS_COMPILE_TARGET)-gcc --sysroot=$(ROOTFS)" \
		LDFLAGS="-L$(ROOTFS_PREFIX)/lib64" \
		vim_cv_getcwd_broken=no \
		vim_cv_memmove_handles_overlap=yes \
		vim_cv_stat_ignores_slash=no \
		vim_cv_terminfo=yes \
		vim_cv_toupper_broken=no \
		vim_cv_tty_group=world \
		./configure \
		$(INSTALL_DIRS) \
		--build=x86_64-unknown-linux-gnu \
		--host=$(CROSS_COMPILE_TARGET) \
		--with-local-dir=$(ROOTFS_PREFIX) \
		--enable-multibyte \
		--enable-gui=no \
		--disable-gtktest \
		--disable-xim \
		--with-features=normal \
		--disable-gpm \
		--without-x \
		--disable-netbeans \
		--disable-nls
	@cd $(DIR_WORKING)/$@; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make $(MAKE_FLAGS)
	@cd $(DIR_WORKING)/$@; \
		PATH=$(TEMP_ROOTFS_PREFIX)/bin:$${PATH} \
		make install
	$(making-end)
	exit 1
		#--with-tlib=ncurses

