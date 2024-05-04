CPPFLAGS = $(shell pkg-config --cflags libgit2)
CFLAGS = -Wall -Wextra
LDFLAGS = $(shell pkg-config --libs-only-L libgit2)
LDLIBS = $(shell pkg-config --libs-only-l libgit2)

.PHONY: debug release

debug: CFLAGS += -ggdb
debug: prompt

release: CFLAGS += -flto -O2 -std=c11
release: CPPFLAGS += -DNDEBUG
release: prompt
