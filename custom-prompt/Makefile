CFLAGS = -flto -O2 -std=c11 -Wall -Wextra
LDFLAGS = -flto -O2

ifneq "$(OS)" "Windows_NT"
    UNAME = $(shell uname)
    ifeq "$(UNAME)" "Linux"
        LDLIBS += $(shell pkg-config --libs x11)
    endif
endif

MainSource = custom-prompt.c
MainBashObject = custom-bash-prompt.o
MainBashExecutable = $(MainBashObject:.o=)
MainZshObject = custom-zsh-prompt.o
MainZshExecutable = $(MainZshObject:.o=)
GetActiveWindowIdObjects = get_active_window_id_linux.o get_active_window_id_macos.o get_active_window_id_windows.o
NotifyDesktopObjects = notify_desktop_linux.o notify_desktop_macos_windows.o
Objects = $(GetActiveWindowIdObjects) $(NotifyDesktopObjects)

.PHONY: debug release

debug: $(MainBashExecutable) $(MainZshExecutable)

release: CPPFLAGS += -DNDEBUG
release: LDFLAGS += -s
release: debug

$(MainBashObject): CPPFLAGS += -DBASH
$(MainBashObject): $(MainSource)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $^ -o $@

$(MainBashExecutable): $(MainBashObject) $(Objects)

$(MainZshObject): CPPFLAGS += -DZSH
$(MainZshObject): $(MainSource)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $^ -o $@

$(MainZshExecutable): $(MainZshObject) $(Objects)
