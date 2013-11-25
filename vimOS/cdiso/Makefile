include ../common.mk

SYSLINUX := syslinux-6.02

all: initrd $(SYSLINUX)
	@mkdir -p $(DIR_DIST)/cdiso_root
	@cp $(DIR_WORKING)/$(SYSLINUX)/bios/core/isolinux.bin $(DIR_DIST)/cdiso_root/
	@cp $(DIR_WORKING)/$(SYSLINUX)/bios/com32/elflink/ldlinux/ldlinux.c32 $(DIR_DIST)/cdiso_root/
	@cp isolinux.cfg boot.txt $(DIR_DIST)/cdiso_root/
	@cp $(DIR_DIST)/rootfs/boot/vmlinuz $(DIR_DIST)/cdiso_root/
	@cp $(DIR_DIST)/initrd.gz $(DIR_DIST)/cdiso_root/
	@mkisofs -o $(DIR_DIST)/VimOS.iso \
	    -R -J --joliet-long -hide-joliet boot.catalog \
	    -b isolinux.bin \
	    -input-charset utf-8 \
	    -no-emul-boot -boot-load-size 4 -boot-info-table \
	    $(DIR_DIST)/cdiso_root

initrd:
	@$(DIR_WORKING)/linux-$(KERNEL_VERSION)/usr/gen_init_cpio devlist.txt > $(DIR_DIST)/initrd.cpio
	@cd $(DIR_DIST)/rootfs; find . | cpio --append -c -a -o -F $(DIR_DIST)/initrd.cpio
	@gzip -9 -c -f $(DIR_DIST)/initrd.cpio > $(DIR_DIST)/initrd.gz
	@gzip -t $(DIR_DIST)/initrd.gz

$(SYSLINUX):
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/$(SYSLINUX).tar.xz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/$(SYSLINUX); make -j4 bios
	$(making-end)

clean:
	@rm -f $(SYSLINUX)
	@rm -f *.making

.PHONY: all clean initrd
