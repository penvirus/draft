define making-start
    @echo ">>> making $@"
endef

define making-end
    @echo ">>> making $@ done"
endef

DIR_3RD_PARTY = $$(pwd)/3rd_party
DIR_WORKING = $$(pwd)/build
DIR_DIST = $$(pwd)/dist

SUBDIR = system

all: build

pre_build:
	$(making-start)
	@mkdir -p $(DIR_WORKING)
	@mkdir -p $(DIR_DIST)
	$(making-end)

build: pre_build
	$(making-start)
	@for sub in $(SUBDIR); do \
	    make DIR_3RD_PARTY=$(DIR_3RD_PARTY) DIR_WORKING=$(DIR_WORKING) DIR_DIST=$(DIR_DIST) -C $$sub; \
	done
	$(making-end)

clean:
	$(making-start)
	@for sub in $(SUBDIR); do \
	    make DIR_3RD_PARTY=$(DIR_3RD_PARTY) DIR_WORKING=$(DIR_WORKING) DIR_DIST=$(DIR_DIST) -C $$sub clean; \
	done
	@rm -rf $(DIR_WORKING)
	@rm -rf $(DIR_DIST)
	$(making-end)

.PHONY: all clean
