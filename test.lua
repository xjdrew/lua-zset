local c = require "skiplist.c"

local sl = c()

sl:insert(100, "a")
sl:insert(200, "b")
sl:insert(150, "c")

sl:dump()

print(sl:get_rank(100, "a"))
print(sl:get_rank(100, "b"))
print(sl:get_member_by_rank(3))

