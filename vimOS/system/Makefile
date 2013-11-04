GRUB_VERSION = 2.00

APPS += grub

all:
	@mkdir -p $(DIR_DIST)/rootfs/
	@for app in $(APPS); do \
	    make $$app; \
	done

grub:
	$(making-start)
	@tar Jxf $(DIR_3RD_PARTY)/grub-$(GRUB_VERSION).tar.xz -C $(DIR_WORKING)
	@cd $(DIR_WORKING)/grub-$(GRUB_VERSION); ./configure --prefix=$(DIR_DIST)/rootfs; make install
	$(making-end)

clean:
	$(making-start)
	$(making-end)

.PHONY: all clean
