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
