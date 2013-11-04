include ../common.mk

SYSLINUX := syslinux-6.02

all: $(SYSLINUX)

$(SYSLINUX):
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/syslinux-$(SYSLINUX_VERSION).tar.xz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/syslinux-$(SYSLINUX_VERSION); make MAKEDIR=../mk SRC=. objdir=../efi64 -C linux/
	$(making-end)

clean:
	$(making-start)
	$(making-end)

.PHONY: all clean
