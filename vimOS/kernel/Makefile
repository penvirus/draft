KERNEL_VERSION = 2.6.34

all: kernel

extract_kernel:
	$(start)
	@cd $(DIR_3RD_PARTY); tar Jxf linux-$(KERNEL_VERSION).tar.xz -C $(DIR_WORKING)
	$(end)

kernel: extract_kernel
	$(start)
	@cp config $(DIR_WORKING)/linux-$(KERNEL_VERSION)/.config
	@cp install.sh $(DIR_WORKING)/linux-$(KERNEL_VERSION)/arch/x86/boot/
	@cd $(DIR_WORKING)/linux-$(KERNEL_VERSION); \
	    make oldconfig && \
	    make -j4 bzImage && \
	    make -j4 modules && \
	    make INSTALL_MOD_PATH=$(DIR_DIST) modules_install && \
	    make INSTALL_PATH=$(DIR_DIST) install
	@rm -f $(DIR_DIST)/lib/modules/$(KERNEL_VERSION)-VimOS/{source,build}
	$(end)

clean:
	$(start)
	$(end)

.PHONY: all clean
