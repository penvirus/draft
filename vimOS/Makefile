start = @echo ">>> making $@"
end = @echo ">>> making $@ done"

DIR_3RD_PARTY = $$(pwd)/3rd_party
DIR_WORKING = $$(pwd)/build
DIR_DIST = $$(pwd)/dist

SUBDIR = kernel

all: build

pre_build:
	$(start)
	@mkdir -p $(DIR_WORKING)
	@mkdir -p $(DIR_DIST)
	$(end)

build: pre_build
	$(start)
	@for sub in $(SUBDIR); do \
	    make DIR_3RD_PARTY=$(DIR_3RD_PARTY) DIR_WORKING=$(DIR_WORKING) DIR_DIST=$(DIR_DIST) -C $$sub; \
	done
	$(end)

clean:
	$(start)
	@for sub in $(SUBDIR); do \
	    make DIR_3RD_PARTY=$(DIR_3RD_PARTY) DIR_WORKING=$(DIR_WORKING) DIR_DIST=$(DIR_DIST) -C $$sub clean; \
	done
	@rm -rf $(DIR_WORKING)
	@rm -rf $(DIR_DIST)
	$(end)

.PHONY: all clean
