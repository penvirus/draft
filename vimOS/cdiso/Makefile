include ../common.mk

SYSLINUX := syslinux-6.02

all: $(SYSLINUX)
	@mkdir -p $(DIR_DIST)/rootfs/isolinux
	@cp $(DIR_WORKING)/$(SYSLINUX)/bios/core/isolinux.bin $(DIR_DIST)/rootfs/isolinux/
	@cp isolinux.cfg boot.txt $(DIR_DIST)/rootfs/isolinux/
	@mkdir -p $(DIR_DIST)/rootfs/images
	@mkdir -p $(DIR_DIST)/rootfs/kernel
	@cp $(DIR_WORKING)/$(SYSLINUX)/bios/memdisk/memdisk $(DIR_DIST)/rootfs/kernel
	@mkisofs -o $(DIR_DIST)/VimOS.iso \
	    -b isolinux/isolinux.bin -c isolinux/boot.cat \
	    -no-emul-boot -boot-load-size 4 -boot-info-table \
	    $(DIR_DIST)/rootfs

$(SYSLINUX):
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(SYSLINUX).tar.xz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(SYSLINUX); make bios
	$(making-end)

clean:
	$(making-start)
	$(making-end)

.PHONY: all clean
