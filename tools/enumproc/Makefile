CC := gcc
CFLAGS := -std=gnu17 -O3 -Wall -Wextra -Wpedantic -Wconversion -Wno-sign-conversion -Werror
INCLUDE_DIRS := .

SRCS := enumproc.c libenum.c libexpr.c
INCLUDES = $(addprefix -I,$(INCLUDE_DIRS))

.PHONY: all clean

all: enumproc

clean:
	$(RM) moveproc$(EXE)

enumproc: $(SRCS)
	$(CC) $(CFLAGS) $^ $(INCLUDES) -o $@
