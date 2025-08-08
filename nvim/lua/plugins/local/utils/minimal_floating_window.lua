local M = {}

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

---@param bufnr integer
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

return M
