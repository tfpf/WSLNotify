CFLAGS = -flto -O2 -std=c11 -Wall -Wextra
LDFLAGS = -flto -O2

ifneq "$(OS)" "Windows_NT"
    UNAME = $(shell uname)
    ifeq "$(UNAME)" "Linux"
        LDLIBS += -lX11
    endif
endif

MainSource = custom-prompt.c
MainBashObject = custom-bash-prompt.o
MainBashExecutable = $(MainBashObject:.o=)
MainZshObject = custom-zsh-prompt.o
MainZshExecutable = $(MainZshObject:.o=)
GetActiveWindowSources = get_active_window_id_linux.c get_active_window_id_macos.c get_active_window_id_windows.c
GetActiveWindowObjects = $(GetActiveWindowSources:.c=.o)

.PHONY: debug release

debug: $(MainBashExecutable) $(MainZshExecutable)

release: CPPFLAGS += -DNDEBUG
release: LDFLAGS += -s
release: debug

$(MainBashObject): CPPFLAGS += -DBASH
$(MainBashObject): $(MainSource)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $^ -o $@

$(MainBashExecutable): $(MainBashObject) $(GetActiveWindowObjects)

$(MainZshObject): CPPFLAGS += -DZSH
$(MainZshObject): $(MainSource)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $^ -o $@

$(MainZshExecutable): $(MainZshObject) $(GetActiveWindowObjects)
