local M = {}

---Split string by pattern
---@param s string
---@param pattern string
---@return table<string>
function M.splitString(s, pattern)
	local res = {}
	for match in string.gmatch(s:sub(-1, -1) == pattern and s or s .. pattern, "(.-)" .. pattern) do --`-` is non-greedy search, which stop after first found specified character
		if (match ~= nil) and (match ~= "") and (match ~= " ") then
			table.insert(res, match)
		end
	end

	return res
end

---Highlight instances that change status between active and inactive
---@param active_ins string|number
---@param inactive_ins string|number
---@param list table<string>
function M.highlightActiveInstance(active_ins, inactive_ins, list)
	for row, value in ipairs(list) do
		local tokens = M.splitString(value, " ")
		if tonumber(tokens[1]) == active_ins then
			vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 1, { "*" }) -- the HOSTING_INDICATOR column is 0-beginning of the line-as default, change from colum 0 to 1 to replace, otherwise, it'll insert if specifying column 0 to 0
		elseif tonumber(tokens[1]:sub(2, -1)) == inactive_ins then
			vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 1, { " " })
		end
	end
end

---@return table<string, integer>
---@return table<string, integer>
function M.calculateFloatingWindowSizes()
	local width = {
		start = ((1 - 0.4) / 2) * vim.o.columns,
		magnitude = math.ceil(vim.o.columns * 0.4),
	}
	local height = {
		start = ((1 - 0.4) / 2) * vim.o.lines,
		magnitude = math.ceil(vim.o.lines * 0.4),
	}

	return width, height
end

---@param bufnr number
---@param title string
function M.openFloatingWindow(bufnr, title)
	local width, height = M.calculateFloatingWindowSizes()
	vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		width = width.magnitude,
		height = height.magnitude,
		col = width.start,
		row = height.start,
		style = "minimal",
		border = "rounded",
		title = title,
		title_pos = "center",
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
