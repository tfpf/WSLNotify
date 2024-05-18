CPPFLAGS = -DNDEBUG $(shell pkg-config --cflags libgit2)
CFLAGS = -flto -O2 -std=c11 -Wall -Wextra
LDFLAGS = $(shell pkg-config --libs-only-L libgit2)
LDLIBS = $(shell pkg-config --libs-only-l libgit2)

custom-bash-prompt:
