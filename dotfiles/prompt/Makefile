CPPFLAGS = $(shell pkg-config --cflags libgit2)
CXXFLAGS = -std=c++20 -Wall -Wextra
LDFLAGS = $(shell pkg-config --libs-only-L libgit2)
LDLIBS = $(shell pkg-config --libs-only-l libgit2)

.PHONY: debug release

debug: CFLAGS += -ggdb
debug: prompt

release: CFLAGS += -flto -O2
release: CPPFLAGS += -DNDEBUG
release: prompt
