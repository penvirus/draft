define making-start
    @echo ">>> making $@"
endef

define making-end
    @echo ">>> making $@ done"
endef

DIR_3RD_PARTY = $(shell pwd)/3rd_party
DIR_WORKING = $(shell pwd)/build
DIR_DIST = $(shell pwd)/dist

SUBDIRS = kernel system live-cd

all: build

pre_build:
	@mkdir -p $(DIR_WORKING)
	@mkdir -p $(DIR_DIST)

build: pre_build
	$(making-start)
	@for sub in $(SUBDIRS); do \
	    make $$sub; \
	done
	$(making-end)

$(SUBDIRS): pre_build
	$(making-start)
	    @make DIR_3RD_PARTY=$(DIR_3RD_PARTY) DIR_WORKING=$(DIR_WORKING) DIR_DIST=$(DIR_DIST) -C $@; \
	$(making-end)

clean:
	$(making-start)
	@for sub in $(SUBDIRS); do \
	    make DIR_3RD_PARTY=$(DIR_3RD_PARTY) DIR_WORKING=$(DIR_WORKING) DIR_DIST=$(DIR_DIST) -C $$sub $@; \
	done
	@rm -rf $(DIR_WORKING)
	@rm -rf $(DIR_DIST)
	$(making-end)

.PHONY: all clean
