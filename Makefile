all: skiplist.so

CC = gcc
CFLAGS = -g3 -O0 -Wall -fPIC --shared
LUA_INCLUDE_DIR = /usr/local/include
DEFS = -DLUA_COMPAT_5_2
BUILD_CFLAGS = $(CFLAGS) $(DEFS)  -I$(LUA_INCLUDE_DIR) 

skiplist.so: skiplist.h skiplist.c lua-skiplist.c
	$(CC)  $(BUILD_CFLAGS)  $^ -o $@

test:
	lua test_sl.lua

clean:
	-rm skiplist.so
