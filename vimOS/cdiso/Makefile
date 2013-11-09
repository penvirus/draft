include ../common.mk

SYSLINUX := syslinux-6.02

all: $(SYSLINUX)
	@mkdir -p $(DIR_DIST)/cdiso_root
	@cp $(DIR_WORKING)/$(SYSLINUX)/bios/core/isolinux.bin $(DIR_DIST)/cdiso_root/
	@cp isolinux.cfg boot.txt $(DIR_DIST)/cdiso_root/
	@cp $(DIR_DIST)/rootfs/boot/vmlinuz $(DIR_DIST)/cdiso_root/
	@cp $(DIR_DIST)/initrd.gz $(DIR_DIST)/cdiso_root/
	@mkisofs -o $(DIR_DIST)/VimOS.iso \
	    -b isolinux.bin -c boot.cat \
	    -no-emul-boot -boot-load-size 4 -boot-info-table \
	    $(DIR_DIST)/cdiso_root

$(SYSLINUX):
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(SYSLINUX).tar.xz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(SYSLINUX); make bios
	$(making-end)

clean:
	$(making-start)
	$(making-end)

.PHONY: all clean
