# Compilation options
CC = gcc
CFLAGS = -O3 -Wall -pedantic -DNDEBUG -DUSE_MEM_HOOK
TARGET = skiplist.so

# Check the OS type
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Darwin)
	LDFLAGS = -bundle -undefined dynamic_lookup
	# Assuming you installed lua using homebrew
	# If not, you need to change to your own lua include path
	LUA_VERSION := $(shell lua -v 2>&1 | sed -E 's/.*Lua ([0-9\.]+).*/\1/')
	LUA_INCLUDE ?= /opt/homebrew/Cellar/lua/$(LUA_VERSION)/include/lua
else
	LDFLAGS = -shared
	LUA_INCLUDE ?= /usr/local/include
endif

# Default target
all: $(TARGET)

luajit: LUA_INCLUDE = /usr/local/include/luajit-2.1
luajit: $(TARGET)

# Source files
SRC_FILES = lua-skiplist.c skiplist.c
HEADER_FILES = skiplist.h

# Compile source files
$(TARGET): $(SRC_FILES) $(HEADER_FILES)
	$(CC) $(CFLAGS) -I$(LUA_INCLUDE) -o $@ $(SRC_FILES) $(LDFLAGS)

test:
	lua test.lua
	lua test_sl.lua

clean:
	rm -f $(TARGET)

.PHONY: all clean

