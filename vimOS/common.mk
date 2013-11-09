define making-start
    @date >> $@.making
    @echo ">>> making $@"
endef

define making-end
    @mv $@.making $@
    @echo ">>> making $@ done"
endef
