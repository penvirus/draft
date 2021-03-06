define making-start
	@date >> $@.making
	@echo ">>> making $@"
	@rm -rf $(DIR_WORKING)/$@
endef

define making-end
	@mv $@.making $@
	@echo ">>> making $@ done"
endef

KERNEL_VERSION := 2.6.34
CROSS_COMPILE_TARGET := x86_64-vimos-linux-gnu
MAKE_FLAGS := -j$(shell lscpu | grep '^CPU(s):' | awk '{print $$2}')
