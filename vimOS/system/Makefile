include ../common.mk

GLIBC := glibc-2.18
BASH := bash-4.2

GRUB_VERSION := 2.00

PKGS += $(GLIBC)
PKGS += $(BASH)

all:
	@cp init $(DIR_DIST)/rootfs/
	@chmod 775 $(DIR_DIST)/rootfs/init
	@for pkg in $(PKGS); do \
	    $(MAKE) $$pkg; \
	done

grub:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/grub-$(GRUB_VERSION).tar.xz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/grub-$(GRUB_VERSION); ./configure --prefix=$(DIR_DIST)/rootfs; \
	    make install
	$(making-end)

$(GLIBC):
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(GLIBC).tar.xz -C $(DIR_WORKING)
	@mkdir -p $(DIR_WORKING)/$(GLIBC)/tmp_build
	@cd $(DIR_WORKING)/$(GLIBC)/tmp_build; ../configure --prefix=$(DIR_DIST)/rootfs --libdir=$(DIR_DIST)/rootfs/lib64 \
	    --enable-stackguard-randomization --enable-all-warnings \
	    && make all && make install
	$(making-end)

$(BASH): $(GLIBC)
	$(making-start)
	@tar zxf $(DIR_3RD_PARTY)/$(BASH).tar.gz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(BASH); ./configure --prefix=$(DIR_DIST)/rootfs/ \
	    --enable-alias --enable-arith-for-command --enable-array-variables \
	    --enable-brace-expansion --enable-debugger --enable-directory-stack --enable-dparen-arithmetic \
	    --enable-help-builtin --enable-history --enable-job-control --enable-net-redirections --enable-readline \
	    --enable-select --disable-rpath && make install
	#@cp /lib64/libdl.so.2 $(DIR_DIST)/rootfs/lib64/
	#@cp /lib64/libc.so.6 $(DIR_DIST)/rootfs/lib64/
	#@cp /lib64/ld-linux-x86-64.so.2 $(DIR_DIST)/rootfs/lib64/
	$(making-end)

clean:
	@rm -f $(PKGS)
	@rm -f *.making

.PHONY: all clean
