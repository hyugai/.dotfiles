--find `--!` to go into tasks needed completing
local utils = require("switcher.utils")
local sb = require("switcher.sb")
local fw = require("switcher.fw")

local M = {
	---buf'ID(key): host window'ID or false as default(value)
	BUFFER = {
		---@type table<integer, integer|boolean>
		ids_hosted = {},

		---@type integer
		id_scratch = nil,
	},

	WINDOW = {
		---@type integer
		id_floating = nil,

		---@type integer
		id_host = nil,

		opts = {
			relative = "editor",
			width = 0,
			height = 0,
			col = 0,
			row = 0,
			style = "minimal",
			border = "rounded",
			title = "foo",
			title_pos = "center",
		},
	},
}

--!: solve the process of this plugin
--!: break down the `foo` function
--BUFFER.scratch: not avail => create one, avail => if FLOATING_WINDOW.id not avail, create one and update BUFFER.scratch
--update `BUFFER.scratch`: remove buffers of newly deleted files
function M:open()
	--
	--list buffers and find hosted ones
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and utils.verifyFile(vim.api.nvim_buf_get_name(bufnr)) then --!: find ways to exclude NvimTree_ buffer
			self.BUFFER.ids_hosted[bufnr] = false
		end
	end

	for _, winnr in ipairs(vim.api.nvim_list_wins()) do
		self.BUFFER.ids_hosted[vim.api.nvim_win_get_buf(winnr)] = winnr
	end

	--annotate hosted buffers
	---@type table<integer, table<integer, string>>
	local annotated_hosted_bufs = {}
	for bufnr, winnr in pairs(self.BUFFER.ids_hosted) do
		local abbreviated_path = utils.abbreviateHomeDir(vim.api.nvim_buf_get_name(bufnr):gsub(vim.fn.getcwd(), "."))
		table.insert(annotated_hosted_bufs, {
			bufnr .. (self.BUFFER.ids_hosted[bufnr] and "*" or " "),
			abbreviated_path,
		})
	end

	--align words of each line
	local max_length = 0
	for _, str_list in ipairs(annotated_hosted_bufs) do
		max_length = max_length > str_list[1]:len() and max_length or str_list[1]:len()
	end

	local aligned_lines = {}
	for _, str_list in ipairs(annotated_hosted_bufs) do
		local length_diff = max_length - str_list[1]:len()
		str_list[1] = (" "):rep(length_diff + 1) .. str_list[1]

		table.insert(aligned_lines, table.concat(str_list, (" "):rep(2)))
	end

	--#
	self.WINDOW.id_host = vim.api.nvim_get_current_win()
	self.BUFFER.id_scratch = sb.create()
	vim.api.nvim_buf_set_lines(self.BUFFER.id_scratch, 0, -1, true, aligned_lines)

	--!: complete this part
	fw.setOpts({}, {}, self.WINDOW.opts)
	self.WINDOW.id_floating = vim.api.nvim_open_win(self.BUFFER.id_scratch, true, self.WINDOW.opts)
	--#
end

--hide floating window only, keep scratch buffer
function M:hide()
	vim.api.nvim_win_hide(self.WINDOW.id_floating)
	self.WINDOW.id_floating = false
end

function M:reOpen()
	--remove lines containing deleted files' buffers
	local bufnrs_update = vim.api.nvim_list_bufs()
	local bufnrs_previous_call = vim.tbl_keys(self.BUFFER.ids_hosted)
	for row, bufnr in ipairs(bufnrs_previous_call) do
		if vim.tbl_contains(bufnrs_update, bufnr) then
			self.BUFFER.ids_hosted[bufnr] = nil --remove key from table
			--vim.api.nvim_buf_set_lines(self.BUFFER.id_scratch, row - 1, row, true, {})
		end
	end

	--re-annotate hosted buffers

	--!: complete this part
	--re-open floating window
	self.WINDOW.id_floating = vim.api.nvim_open_win(self.BUFFER.id_scratch, true, self.WINDOW.opts)
end
function M:switchBuf()
	--attach selected buffer to previous window
	--re-annotate hosted buffers
end
function M:toggle()
	if not self.BUFFER.id_scratch then
		self:open()
	elseif not self.WINDOW.id_floating then --`BUFFER.scratch` avail
		self:reOpen()
	else --`WINDOW.floating_id` avail
		self:hide()
	end
end
--M:toggle()

return M
