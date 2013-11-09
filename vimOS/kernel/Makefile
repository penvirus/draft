include ../common.mk

KERNEL_VERSION := 2.6.34

all: initrd

kernel:
	$(making-start)
	@cd $(DIR_3RD_PARTY); tar Jxf linux-$(KERNEL_VERSION).tar.xz -C $(DIR_WORKING)
	@cp -f config $(DIR_WORKING)/linux-$(KERNEL_VERSION)/.config
	@cp install.sh $(DIR_WORKING)/linux-$(KERNEL_VERSION)/arch/x86/boot/
	@cd $(DIR_WORKING)/linux-$(KERNEL_VERSION)/; \
	    make oldconfig && \
	    make prepare && \
	    make modules_prepare && \
	    make -j4 bzImage && \
	    make -j4 modules && \
	    make INSTALL_MOD_PATH=$(DIR_DIST)/rootfs modules_install && \
	    make INSTALL_PATH=$(DIR_DIST)/rootfs/boot install
	@rm -f $(DIR_DIST)/lib/modules/$(KERNEL_VERSION)-VimOS/{source,build}
	$(making-end)

initrd:
	$(making-start)
	@$(DIR_WORKING)/linux-$(KERNEL_VERSION)/usr/gen_init_cpio devlist.txt > $(DIR_DIST)/initrd.cpio
	@cd $(DIR_DIST)/rootfs; find . | cpio --append -c -a -o -F $(DIR_DIST)/initrd.cpio
	@gzip -9 -c -f $(DIR_DIST)/initrd.cpio > $(DIR_DIST)/initrd.gz
	@gzip -t $(DIR_DIST)/initrd.gz
	$(making-end)

clean:
	$(making-start)
	$(making-end)

.PHONY: all clean kernel initrd
