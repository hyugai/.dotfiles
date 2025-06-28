---@class Class
local Class = {}

---@return Class
function Class:new()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	return obj
end

local obj = Class:new()

local M = {
    a = 5
}
M.foo = function(self)
    print(self.a)
end

M:foo()
