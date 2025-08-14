--find `--!` to go into tasks needed completing
local utils = require("switcher.utils")
local sb = require("switcher.sb")
local fw = require("switcher.fw")

local M = {
	---buf'ID(key): host window'ID or false as default(value)
	BUFFER = {
		---@type table<integer, integer>
		ids_hosted = nil,

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

--!: when hide the window, we actually close it since there is no way to reopen it, but we still keep the buffer => how to still keep the buffer when we temporarily close the window
--!: solve the process of this plugin
--!: break down the `foo` function
--BUFFER.scratch: not avail => create one, avail => if FLOATING_WINDOW.id not avail, create one and update BUFFER.scratch
--update `BUFFER.scratch`: remove buffers of newly deleted files
function M:open()
	self.BUFFER.ids_hosted = sb.listVerifiedBufIds()

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
	fw.setOpts({
		height = 0.4,
		width = 0.45,
	}, {
		height = vim.o.lines,
		width = vim.o.columns,
	}, self.WINDOW.opts)
	self.WINDOW.id_floating = vim.api.nvim_open_win(self.BUFFER.id_scratch, true, self.WINDOW.opts)
	vim.api.nvim_win_set_hl_ns(self.WINDOW.id_floating, vim.api.nvim_create_namespace("Switcher"))
	--#

	--!: complete this part
	--when quitting the window, deleted IDs still remain, below codes are the fixes
	--used for this plugin's buffer only
	vim.api.nvim_create_autocmd("WinClosed", {
		buffer = self.BUFFER.id_scratch,
		callback = function(opts)
			self.WINDOW.id_floating = nil
		end,
	})
	--#
end

function M:hide()
	vim.api.nvim_win_hide(self.WINDOW.id_floating) --?: close the window, MAKE BUFFER HIDDEN
	--vim.api.nvim_win_close(self.WINDOW.id_floating, false)
	self.WINDOW.id_floating = nil
end

function M:reOpen()
	local deleted_lines_count = 0
	local is_this_line_deleted = false
	local updated_active_bufnrs = sb.listVerifiedBufIds()

	--!: discover new bufs
	--iter each line, determine if line should be deleted or not
	for row, line in ipairs(vim.api.nvim_buf_get_lines(self.BUFFER.id_scratch, 0, -1, true)) do
		local tokens = utils.splitString(line, " ")
		local bufnr = utils.splitString(tokens[1], "%*")[1]
		local hosting_indicator = utils.splitString(tokens[1], "%d")[1]

		if vim.tbl_contains(updated_active_bufnrs, bufnr) then
			vim.api.nvim_buf_set_lines(
				self.BUFFER.id_scratch,
				row - 1 - deleted_lines_count,
				row - deleted_lines_count,
				true,
				{}
			)
			deleted_lines_count = deleted_lines_count + 1
			is_this_line_deleted = true
		elseif is_this_line_deleted then
			is_this_line_deleted = false

			--!: if this buffer is still being hosted, do nothing
			if updated_active_bufnrs[bufnr] then
				if not hosting_indicator then --highlight if newly hosted but there's no indicator
				end
			else
				if hosting_indicator then --remove indicator if it used to have one (used to be hosted)
				end
			end
		end
	end

	--?: do NOT touch this part
	--re-open floating window
	self.WINDOW.id_floating = vim.api.nvim_open_win(self.BUFFER.id_scratch, true, self.WINDOW.opts)
	vim.api.nvim_win_set_hl_ns(self.WINDOW.id_floating, vim.api.nvim_create_namespace("Switcher"))
end
function M:switchBuf()
	--attach selected buffer to previous window
	--re-annotate hosted buffers
end

--!: how to distinguish between close window with removing its buffer and hide window (close temporarily) without removing its
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
