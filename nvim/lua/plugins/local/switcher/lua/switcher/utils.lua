local M = {}

---Split string by pattern
---@param s string
---@param pattern string
---@return table<string>
function M.splitString(s, pattern)
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
function M.asDict(list, default_value)
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
function M.highlightActiveInstance(active_ins, inactive_ins, list)
	for row, value in ipairs(list) do
		if value:sub(1, 1) == active_ins then
			vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, { "*" }) -- the HOSTING_INDICATOR column is 0-beginning of the line-as default
		elseif value:sub(1, 1) == inactive_ins then
			vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, { " " })
		end
	end
end

---@return table<string, integer>
---@return table<string, integer>
function M.calculateFloatingWindowSizes()
	local width = {
		start = ((1 - 0.5) / 2) * vim.o.columns,
		magnitude = math.ceil(vim.o.columns * 0.5),
	}
	local height = {
		start = ((1 - 0.5) / 2) * vim.o.lines,
		magnitude = math.ceil(vim.o.lines * 0.5),
	}

	return width, height
end

---@param bufnr number
function M.openFloatingWindow(bufnr)
	local width, height = M.calculateFloatingWindowSizes()
	vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		width = width.magnitude,
		height = height.magnitude,
		col = width.start,
		row = height.start,
		style = "minimal",
		border = "rounded",
	})
end

---@return integer
function M.createScratchBuf()
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = bufnr })
	vim.api.nvim_set_option_value("swapfile", false, { buf = bufnr })

	return bufnr
end

return M
