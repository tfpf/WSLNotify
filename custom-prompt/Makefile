CPPFLAGS = -DNDEBUG
CFLAGS = -flto -O2 -std=c11 -Wall -Wextra

ifneq "$(OS)" "Windows_NT"
    UNAME = $(shell uname)
    ifeq "$(UNAME)" "Linux"
        LDLIBS = -lX11
    endif
endif

Sources = $(wildcard *.c)

.PHONY: all

all: custom-bash-prompt custom-zsh-prompt

custom-bash-prompt: $(Sources)
	$(CC) $(CPPFLAGS) -DBASH $(CFLAGS) $^ $(LDLIBS) -o $@

custom-zsh-prompt: $(Sources)
	$(CC) $(CPPFLAGS) -DZSH $(CFLAGS) $^ $(LDLIBS) -o $@
