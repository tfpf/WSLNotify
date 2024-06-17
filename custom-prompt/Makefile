CFLAGS = -flto -O2 -std=c11 -Wall -Wextra

ifneq "$(OS)" "Windows_NT"
    UNAME = $(shell uname)
    ifeq "$(UNAME)" "Linux"
        LDLIBS += -lX11
    endif
endif

Sources = $(wildcard *.c)

.PHONY: debug release

debug: custom-bash-prompt custom-zsh-prompt

release: CPPFLAGS += -DNDEBUG
release: debug

custom-bash-prompt: CPPFLAGS += -DBASH
custom-bash-prompt: $(Sources)
	$(CC) $(CPPFLAGS) $(CFLAGS) $^ $(LDLIBS) -o $@

custom-zsh-prompt: CPPFLAGS += -DZSH
custom-zsh-prompt: $(Sources)
	$(CC) $(CPPFLAGS) $(CFLAGS) $^ $(LDLIBS) -o $@
