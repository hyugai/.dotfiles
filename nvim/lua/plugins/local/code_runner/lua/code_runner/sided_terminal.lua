local scratch_buffer = require("code_runner.scratch_buffer")

local M = {
	EDITOR = {
		width = vim.o.columns,
		height = vim.o.lines,
	},
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
			title = "NeoVim Integrated Terminal",
			title_pos = "right",
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

---@param cmds nil|string
function M:open(cmds)
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
	if cmds then
		vim.defer_fn(function()
			vim.api.nvim_chan_send(self.PID, cmds .. "\n") --?:use `\n` in place of `Enter`
		end, 1000)
	end
end
--#

function M:hide()
	vim.api.nvim_win_hide(self.WINDOW.id) --?:hide both window and buffer
	self.WINDOW.id = nil --?:remove closed window's ID
end

function M:reOpen(cmds)
	self.WINDOW.id = vim.api.nvim_open_win(self.BUFFER.id, true, self.WINDOW.opts) --?:reassign new window's ID
	vim.api.nvim_cmd({ cmd = "startinsert" }, { output = false }) --?:get into `Terminal` mode at inititation
	vim.api.nvim_win_set_hl_ns(self.WINDOW.id, vim.api.nvim_create_namespace("CodeRunner"))
	if cmds then
		vim.defer_fn(function()
			vim.api.nvim_chan_send(self.PID, cmds .. "\n") --?:use `\n` in place of `Enter`
		end, 1000)
	end
end

--#
---@param length integer
function M:lift(length) end
--#

--#
function M:autoResize()
	if self.WINDOW.id and vim.api.nvim_win_is_valid(self.WINDOW.id) then --?: this will make sure this function will only be effective inside plugin's cope
		local new_sizes = {
			width = vim.o.columns,
			height = vim.o.lines,
		}
		if (new_sizes.height ~= self.EDITOR.height) or (new_sizes.width ~= self.EDITOR.width) then
			--update
			self.EDITOR.height = new_sizes.height
			self.EDITOR.width = new_sizes.width

			--update
			self.WINDOW.opts["height"] = math.ceil(new_sizes.height / 2)
			self.WINDOW.opts["width"] = new_sizes.width
			vim.api.nvim_win_set_config(self.WINDOW.id, self.WINDOW.opts)
		end
	end
end
--#

--#
function M:init(initial_cmds)
	if not self.PID then --?:create if not available
		self:open(initial_cmds)
	else
		self:reOpen(initial_cmds)
	end
end
--#

return M
