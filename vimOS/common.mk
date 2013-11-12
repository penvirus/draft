define making-start
    @date >> $@.making
    @echo ">>> making $@"
endef

define making-end
    @mv $@.making $@
    @echo ">>> making $@ done"
endef

KERNEL_VERSION := 2.6.34
CROSS_COMPILE_TARGET := x86_64-vimos-linux-gnu
