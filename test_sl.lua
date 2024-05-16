local c = require "skiplist.c"

local sl = c()

local total = 500000
for i=1, total do
    sl:insert(i, tostring(i))
    sl:insert(i, tostring(i))
end

for i=1, total do
    sl:delete(i, tostring(i))
end

--[[
assert(sl:get_rank(1, "1") == 1)
assert(sl:get_rank(total, tostring(total)) == total)

local rand = math.random(total)
print(rand)
assert(sl:get_rank(rand, tostring(rand)) == rand)
]]

local a1, a2 = 100, 100000
local t1 = sl:get_rank_range(a1, a2)
local t2 = sl:get_rank_range(a2, a1)
assert(#t1 == #t2)
for i, name in pairs(t1) do
    assert(name == t2[#t2 -i + 1], name)
end

local a1, a2 = 100, 100000
local t1 = sl:get_score_range(a1, a2)
local t2 = sl:get_score_range(a2, a1)
assert(#t1 == #t2)
for i, name in pairs(t1) do
    assert(name == t2[#t2 -i + 1], name)
end

local function dump_rank_range(sl, r1, r2)
    print("rank range:", r1, r2)
    local t = sl:get_rank_range(r1, r2)
    for i, name in ipairs(t) do
        if r1 <= r2 then
            print(r1+(i-1), name)
        else
            print(r1-(i-1), name)
        end
    end
end

local r1, r2 = 2, 5
dump_rank_range(sl, r1, r2)
dump_rank_range(sl, r2, r1)

local function dump_score_range(sl, s1, s2)
    print("score range:", s1, s2)
    local t = sl:get_score_range(s1, s2)
    for _, name in ipairs(t) do
        print(name)
    end
end

local s1, s2 = 10, 20
dump_score_range(sl, s1, s2)
dump_score_range(sl, s2, s1)

local function delete_cb(member)
    print("delete:", member)
end
sl:delete_by_rank(15, 10, delete_cb)
sl:delete_by_score(100, 105, delete_cb)

print("before gc:", collectgarbage("count"))
sl = nil
collectgarbage("collect")
print("after gc:", collectgarbage("count"))

