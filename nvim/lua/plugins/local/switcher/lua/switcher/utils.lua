local M = {}

---Get index of the first value needed to find from a list
---@param list table<number|string>
---@param value_to_find number|string
---@return number|nil
function M.find_value_from_list(list, value_to_find)
	for index, value in ipairs(list) do
		if value == value_to_find then
			return index
		end
	end
end

--[[
--General methods for each buffer's instance: those methods should require independent parameters
    => new: initialize new empty buffer(instance)
    => 
]]
---@class Buffer
local Buffer = {}

---@return Buffer
function Buffer:new()
	local obj = {
		ID = nil,
	}
	setmetatable(obj, self) -- when indexing nil keys or nil values, fall back on `buffer`
	self.__index = self -- use `Buffer` itself as metatable for its instances

	return obj
end

--[[
--General method for each window's instance
    => new
    =>
]]
---@class PopupWindow
local PopupWindow = {}

---@return PopupWindow
function PopupWindow:new()
	local obj = {
		POPUP = nil,
		HOST = nil,
	}
	setmetatable(obj, self)
	self.__index = self

	return obj
end

---@return boolean
function PopupWindow:setHost()
	local winnr = vim.api.nvim_get_current_win()
	if vim.api.nvim_win_is_valid(winnr) then
		self.HOST = winnr

		return true
	else
		print("Window host is not valid!")

		return false
	end
end

---@param width_ratio number
---@param height_ratio number
---@return table<string, number>
---@return table<string, number>
function PopupWindow.calculateSizes(width_ratio, height_ratio)
	local width = {
		start = ((1 - width_ratio) / 2) * vim.o.columns,
		magnitude = math.ceil(vim.o.columns * width_ratio),
	}
	local height = {
		start = ((1 - height_ratio) / 2) * vim.o.lines,
		magnitude = math.ceil(vim.o.lines * height_ratio),
	}

	return width, height
end

---@param bufnr number
---@param popup_ratio table<string, number>
function PopupWindow:open(bufnr, popup_ratio)
	if self:setHost() then
		local width, height = self.calculateSizes(popup_ratio.width, popup_ratio.height)
		self.POPUP = vim.api.nvim_open_win(bufnr, true, {
			relative = "editor",
			width = width.magnitude,
			height = height.magnitude,
			col = width.start,
			row = height.start,
			style = "minimal",
			border = "rounded",
		})
	end
end

-- EDITOR
local Editor = {
	WIDTH = nil,
	HEIGHT = nil,
}

function Editor:recordCurrentSizes()
	self.WIDTH = vim.o.columns
	self.HEIGHT = vim.o.lines
end

---@return boolean
function Editor:checkSizes() -- use this function along with autocmd triggered by event of "WinResized"
	if (self.WIDTH ~= vim.o.columns) or (self.HEIGHT ~= vim.o.lines) then
		self:recordCurrentSizes()

		return true
	else
		return false
	end
end

--#
return M
