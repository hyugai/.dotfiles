local scratch_buffer = require("code_runner.scratch_buffer")

local M = {
	WINDOW = {
		---@type integer
		id = nil,
		---@type table<string, string|integer|boolean>
		opts = {
			relative = "editor",
			row = math.ceil(vim.o.lines / 2),
			col = 0,
			width = vim.o.columns,
			height = math.ceil(vim.o.lines / 2),
			style = "minimal",
			border = "rounded",
			title = "Terminal",
			title_pos = "center",
			--noautocmd = true,
		},
	},
	BUFFER = {
		---@type integer
		id = nil,
	},
	---@type integer
	PID = nil,
}

---@param cmd nil|string
function M:open(cmd)
	--scratch buffer
	self.BUFFER.id = scratch_buffer.createMutableScratchBuf()

	--window
	self.WINDOW.id = vim.api.nvim_open_win(self.BUFFER.id, true, self.WINDOW.opts)
	--define a seperate namespace to prevent plugins conflict
	vim.api.nvim_win_set_hl_ns(self.WINDOW.id, vim.api.nvim_create_namespace("CodeRunner"))

	--sided terminal
	self.PID = vim.fn.jobstart(vim.o.shell, {
		term = true,
		on_exit = function()
			vim.api.nvim_cmd({ cmd = "q" }, { output = false }) --?:exit sided window after termination of this (terminal) process
			self.PID = nil --?:remove PID in termination of the terminal
		end,
	})
	if self.PID == 0 then
		print("Invalid arguments!")
	elseif self.PID == -1 then
		print("Command is not executable!")
	else
		vim.api.nvim_cmd({ cmd = "startinsert" }, { output = false }) --?:get into `Terminal` mode at inititation
	end
	--command executed at inititation
	if cmd then
		vim.defer_fn(function()
			vim.api.nvim_chan_send(self.PID, cmd .. "\n") --?:use `\n` in place of `Enter`
		end, 1000)
	end
end
--#

function M:hide()
	vim.api.nvim_win_hide(self.WINDOW.id) --?:hide both window and buffer
	self.WINDOW.id = nil --?:remove closed window's ID
end

function M:reOpen()
	self.WINDOW.id = vim.api.nvim_open_win(self.BUFFER.id, true, self.WINDOW.opts) --?:reassign new window's ID
	vim.api.nvim_cmd({ cmd = "startinsert" }, { output = false }) --?:get into `Terminal` mode at inititation
	vim.api.nvim_win_set_hl_ns(self.WINDOW.id, vim.api.nvim_create_namespace("CodeRunner"))
end

--#
---@param length integer
function M:lift(length) end
--#

--#
function M:init(initial_cmd)
	if not self.PID then --?:create if not available
		self:open(initial_cmd)
	else
		self:reOpen()
	end
end
--#

return M
