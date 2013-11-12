include ../common.mk

kernel:
	$(making-start)
	@cd $(DIR_3RD_PARTY); tar Jxf linux-$(KERNEL_VERSION).tar.xz -C $(DIR_WORKING)
	@cp -f config $(DIR_WORKING)/linux-$(KERNEL_VERSION)/.config
	@cp install.sh $(DIR_WORKING)/linux-$(KERNEL_VERSION)/arch/x86/boot/
	@cd $(DIR_WORKING)/linux-$(KERNEL_VERSION)/; \
	    make headers_check && \
	    make INSTALL_HDR_PATH=$(DIR_DIST)/rootfs/usr headers_install
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

clean:
	@rm -f kernel
	@rm -f *.making

.PHONY: all clean
