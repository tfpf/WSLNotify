CPPFLAGS = -DNDEBUG
CFLAGS = -flto -O2 -std=c11 -Wall -Wextra

.PHONY: all

all: custom-bash-prompt custom-zsh-prompt

custom-bash-prompt: custom-prompt.c
	$(CC) $(CPPFLAGS) -DBASH $(CFLAGS) $< -o $@

custom-zsh-prompt: custom-prompt.c
	$(CC) $(CPPFLAGS) -DZSH $(CFLAGS) $< -o $@
