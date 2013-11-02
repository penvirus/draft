KERNEL_VERSION = 2.6.34

all: kernel

extract_kernel:
	$(start)
	@cd $(DIR_3RD_PARTY); tar Jxf linux-$(KERNEL_VERSION).tar.xz -C $(DIR_WORKING)
	$(end)

kernel: extract_kernel
	$(start)
	@cp config $(DIR_WORKING)/linux-$(KERNEL_VERSION)/.config
	@cd $(DIR_WORKING)/linux-$(KERNEL_VERSION); make oldconfig; make bzImage; make modules;
	$(end)

clean:
	$(start)
	$(end)

.PHONY: all clean
