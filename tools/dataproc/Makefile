CC := gcc
CFLAGS := -O3 -Wno-unused-result
INCLUDE_DIRS := src lib lib/include ../nitroarc/lib/include ../enumproc ../../include

SRCS := src/common/cli.c src/common/driver.c src/common/entries.c src/common/lookups.c src/common/outputs.c src/common/strings.c lib/dataproc.c lib/json.c lib/yyjson.c ../enumproc/libenum.c ../enumproc/libexpr.c ../nitroarc/lib/nitroarc.c
INCLUDES = $(addprefix -I,$(INCLUDE_DIRS))

TEMPLATES_DIR := \"tools/dataproc/templates\"
REPO_INCLUDE := \"include\"
REPO_BUILD := \"build\"
DATAPROC_FLAGS := -DTEMPLATES_DIR=$(TEMPLATES_DIR) -DREPO_INCLUDE=$(REPO_INCLUDE) -DREPO_BUILD=$(REPO_BUILD)

.PHONY: all clean

all: moveproc

clean:
	$(RM) moveproc$(EXE)

moveproc: $(SRCS) src/moveproc.c
	$(CC) $(CFLAGS) $(DATAPROC_FLAGS) $^ $(INCLUDES) -o $@
