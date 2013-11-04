include ../common.mk

SYSLINUX := syslinux-6.02

all: $(SYSLINUX)

$(SYSLINUX):
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(SYSLINUX).tar.xz -C $(DIR_WORKING)
	#@cd $(DIR_WORKING)/$(SYSLINUX); make MAKEDIR=../mk SRC=. objdir=../efi64 -C linux/
	@cd $(DIR_WORKING)/$(SYSLINUX); make
	$(making-end)

clean:
	$(making-start)
	$(making-end)

.PHONY: all clean
