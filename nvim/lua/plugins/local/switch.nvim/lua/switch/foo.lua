local Set = {}

function Set.__sub(s1, s2)
	local res = {}
	for key, _ in pairs(s1) do
		if not s2[key] then
			table.insert(res, key)
		end
	end

	return res
end

function Set:new(list)
	local obj = {}
	if #list > 0 then
		for _, value in ipairs(list) do
			obj[value] = true
		end
	end

	setmetatable(obj, self)

	return obj
end

local l1 = { 4, 2, 6 }
local l2 = { 2, 4, 6 }

local s1 = Set:new(l1)
local s2 = Set:new(l2)

local s3 = s1 - s2

local bufnr = vim.fn.bufadd("./lua/switch/buffer.lua")
vim.fn.bufload(bufnr)
print(bufnr)
