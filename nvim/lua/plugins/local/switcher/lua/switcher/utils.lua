local M = {}

---Get index of the first value needed to find from a list
---@param list table<number|string>
---@param value_to_find number|string
---@return number|nil
M.findIndexOfValueInList = function(list, value_to_find)
	for index, value in ipairs(list) do
		if value == value_to_find then
			return index
		end
	end
end

---Split string by pattern
---@param s string
---@param pattern string
---@return table<string>
M.splitString = function(s, pattern)
	local res = {}
	for match in string.gmatch(s:sub(-1, -1) == pattern and s or s .. pattern, "(.-)" .. pattern) do --`-` is non-greedy search, which stop after first found specified character
		if match ~= nil or match ~= "" then
			table.insert(res, match)
		end
	end

	return res
end

---Make list as dict with each value equivalent to a key whose value is one that is specified
---@param list table
---@param default_value any
---@return table
M.asDict = function(list, default_value)
	local res = {}
	for _, value in ipairs(list) do
		res[value] = default_value
	end

	return res
end

---Highlight instances that changed status between active and inactive
---@param active_ins string|number
---@param inactive_ins string|number
---@param list table<string>
M.highlightActiveInstance = function(active_ins, inactive_ins, list)
	for row, value in ipairs(list) do
		if value:sub(1, 1) == active_ins then
			vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, { "*" }) -- the HOSTING_INDICATOR column is 0-beginning of the line-as default
		elseif value:sub(1, 1) == inactive_ins then
			vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, { " " })
		end
	end
end

return M
