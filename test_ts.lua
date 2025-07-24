
local zset = require "zset"

local total = 100

local function random_choose(t)
    if #t == 0 then
        return
    end
    local i = math.random(#t)
    return table.remove(t, i)
end

local function delete_handler(member)
	print("delete", member)
end

local zs = zset.new(delete_handler)

local score = 100
for i=1, total do
    local name = "a" .. i
    local a = i % 2 ~= 0 and score or score/ 2
    zs:add(a, name, i)
end

assert(total == zs:count())

print("rank 28:", zs:rank("a28"))
print("rev rank 28:", zs:rev_rank("a28"))

local t = zs:range(1, 10)
print("rank 1-10:")
for _, name in ipairs(t) do
    print(name)
end

local t = zs:rev_range(1, 10)
print("rev rank 1-10:")
for _, name in ipairs(t) do
    print(name)
end

print("------------------ dump ------------------")
zs:dump()
