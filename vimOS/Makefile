include common.mk

DIR_3RD_PARTY 	:= $(shell pwd)/3rd_party
DIR_WORKING 	:= $(shell pwd)/build
DIR_DIST 	:= $(shell pwd)/dist
export

SUBDIRS = system kernel cdiso

all: build

pre_build:
	@mkdir -p $(DIR_WORKING)
	@mkdir -p $(DIR_DIST)

build: pre_build
	$(making-start)
	@for sub in $(SUBDIRS); do \
	    $(MAKE) $$sub; \
	done
	$(making-end)

$(SUBDIRS): pre_build
	$(making-start)
	$(MAKE) -C $@
	$(making-end)

clean:
	$(making-start)
	@for sub in $(SUBDIRS); do \
	    $(MAKE) -C $$sub $@; \
	done
	@rm -rf $(DIR_WORKING)
	@rm -rf $(DIR_DIST)
	$(making-end)

.PHONY: all clean
