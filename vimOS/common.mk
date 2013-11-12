define making-start
    @date >> $@.making
    @echo ">>> making $@"
endef

define making-end
    @mv $@.making $@
    @echo ">>> making $@ done"
endef

KERNEL_VERSION := 2.6.34
CONFIGURE_HOST := x86_64-VimOS-linux-gnu
