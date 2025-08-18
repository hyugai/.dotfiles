local M = {
	BUFFER = {
		---@type integer
		id_scratch = nil,
	},
	WINDOW = {
		---@type integer
		id_float = nil,

		---@type table<string, integer|string|boolean>
		opts = {
			relative = "editor",
			width = 0,
			height = 0,
			col = 0,
			row = 0,
			style = "minimal",
			border = "rounded",
		},
	},
}

---@return integer
function M:createBuf()
	local bufnr = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_set_option_value("bufhidden", "hide", { buf = bufnr })
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
	vim.api.nvim_set_option_value("swapfile", false, { buf = bufnr })

	return bufnr
end

---@param scale table<string, number>
---@param editor table<string, integer>
---@param opts table<string, integer|string|boolean>
function M:open(scale, editor, opts, lines)
	--print("open")
	--#
	--#end

	--#config_opts
	for key, value in pairs(opts) do
		self.WINDOW.opts[key] = value
	end

	self.WINDOW.opts.height = math.ceil(editor.height * scale.height)
	self.WINDOW.opts.width = math.ceil(editor.width * scale.width)
	self.WINDOW.opts.row = math.ceil(((1 - scale.height) / 2) * editor.height)
	self.WINDOW.opts.col = math.ceil(((1 - scale.width) / 2) * editor.width)
	--#end_config_opts

	--#
	self.BUFFER.id_scratch = self:createBuf()
	vim.api.nvim_buf_set_lines(self.BUFFER.id_scratch, 0, -1, true, lines)

	self.WINDOW.id_float = vim.api.nvim_open_win(self.BUFFER.id_scratch, true, self.WINDOW.opts)
	--#end
end

function M:hide()
	vim.api.nvim_win_hide(self.WINDOW.id_float) --?:closing the window leads to `bufhidden`
	self.WINDOW.id_float = nil
end

---@param func fun()
function M:reOpen(func)
	--#
	func() --?:integrated function
	--#end

	self.WINDOW.id_float = vim.api.nvim_open_win(self.BUFFER.id_scratch, true, self.WINDOW.opts)
	vim.api.nvim_win_set_hl_ns(self.WINDOW.id_float, vim.api.nvim_create_namespace("switch.nvim"))
	--vim.api.nvim_win_set_hl_ns(self.WINDOW.id_float, vim.api.nvim_create_namespace("switch.nvim"))
end

function M:terminate()
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = self.BUFFER.id_scratch }) --?:`wipe` means `unloaded` from memory
	vim.api.nvim_buf_delete(self.BUFFER.id_scratch, { force = true }) --?:due to `wipe`, window no longer attach to any buffer. Therefore, it'll close automatically

	self.BUFFER.id_scratch = nil
	self.WINDOW.id_float = nil
end

return M
