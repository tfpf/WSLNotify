CPPFLAGS = $(shell pkg-config --cflags libgit2)
CFLAGS = -std=c11 -O2 -Wall -Wextra -flto
LDFLAGS = $(shell pkg-config --libs-only-L libgit2)
LDLIBS = $(shell pkg-config --libs-only-l libgit2)

.PHONY: debug release

debug: prompt

release: CPPFLAGS += -DNDEBUG
release: prompt
