KERNEL_VERSION = 2.6.34

all: kernel

extract_kernel:
	$(start)
	@cd $(DIR_3RD_PARTY); tar Jxf linux-$(KERNEL_VERSION).tar.xz -C $(DIR_WORKING)
	$(end)

kernel: extract_kernel
	$(start)
	$(end)

clean:
	$(start)
	$(end)

.PHONY: all clean
