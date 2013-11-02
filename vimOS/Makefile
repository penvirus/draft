start = @echo ">>> making $@"
end = @echo ">>> making $@ done"

DIR_3RD_PARTY = 3rd_party
DIR_WORKING = build

SUBDIR = kernel

all: build

pre_build:
	$(start)
	@mkdir -p $(DIR_WORKING)
	$(end)

build: pre_build
	$(start)
	@for sub in $(SUBDIR); do \
	    make DIR_3RD_PARTY=../$(DIR_3RD_PARTY) DIR_WORKING=../$(DIR_WORKING) -C $$sub; \
	done
	$(end)

clean:
	$(start)
	@for sub in $(SUBDIR); do \
	    make DIR_3RD_PARTY=../$(DIR_3RD_PARTY) DIR_WORKING=../$(DIR_WORKING) -C $$sub clean; \
	done
	@rm -rf $(DIR_WORKING)
	$(end)

.PHONY: all clean
