local utils = require("switcher.utils")
local scratch_buffer = require("switcher.scratch_buffer")
local minimal_floating_window = require("switcher.minimal_floating_window")

local M = {
	---@type string
	HOSTING_INDICATOR = "*",

	---buf'ID(key): host window'ID or false as default(value)
	---@type table<integer, integer|boolean>
	HOSTED_BUFS_DICT = {},
}

--#3-level verification: check if a buffer is VALID && LOADED && an EXISTING FILE
---@param bufnr integer
---@return integer|nil
function M.verifyBuf(bufnr)
	if vim.api.nvim_buf_is_loaded(bufnr) then --VALID & LOADED
		local bufInfo = vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr)) --EXISTING
		if bufInfo and bufInfo.type == "file" then --FILE
			return bufnr
		end
	else
		return nil
	end
end

--#Get all buffers passing the 3-level verification
function M:getVerifiedBufs()
	for _, value in ipairs(vim.api.nvim_list_bufs()) do
		local bufnr = self.verifyBuf(value)
		if bufnr then
			--return
			self.HOSTED_BUFS_DICT[bufnr] = false --default (initial) value is false
		end
	end
end

--#Paired buf's ID to a window's ID, whose has beening hosting that buffer
function M:findHostedBufs()
	for _, value in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(value) then
			local bufnr = self.verifyBuf(vim.api.nvim_win_get_buf(value))
			if bufnr then
				--return
				self.HOSTED_BUFS_DICT[bufnr] = value --paired to a winnr, which also means `true` being hosted by a window
			end
		end
	end
end

--#Use this readable format: HOSTING_INDICATOR - BUF'S ID - BUF'S NAME
---@return table<string>
function M:formatOutput()
	local res_list = {}
	for key, value in pairs(self.HOSTED_BUFS_DICT) do
		if self.verifyBuf(key) then --when deleting a file using NeoTree, the list of files names won't be auto-updated, which causes error => re-verify the key, which is `buffnr` again
			local path = string.gsub(vim.api.nvim_buf_get_name(key), vim.fn.getcwd(), ".")
			local hosting_indicator = value and "*" or " " --single line if-else
			table.insert(res_list, hosting_indicator .. tostring(key) .. " " .. path)
		end
	end

	return res_list
end

--#UPDATE AND HIGHLIGHT attached buffers
function M:highlightAttachedBufs(buf_to_attach, buf_to_detach)
	local current_lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
	for row, line in ipairs(current_lines) do
		local words = utils.splitString(line, " ")
		if tonumber(words[1]) == buf_to_attach then
			for col, char in ipairs(utils.iterString(line)) do
				if type(tonumber(char)) == "number" then
					vim.api.nvim_buf_set_text(0, row - 1, col - 2, row - 1, col - 1, { self.HOSTING_INDICATOR }) --`col` is counted backward 2 times, one for 0-based index used in this function, another for position to insert '*' which is not the char `number` itself
					break
				end
			end
		elseif tonumber(words[1]:sub(2, -1)) == buf_to_detach then
			for col, char in ipairs(utils.iterString(line)) do
				if char == "*" then
					vim.api.nvim_buf_set_text(0, row - 1, col - 1, row - 1, col, { " " })
					break
				end
			end
		end
	end
end
--#

--#Triggered when hit `Enter` while being in the floating window
---@param host_winnr integer
function M:switchBuf(host_winnr)
	local tokens = utils.splitString(vim.api.nvim_get_current_line(), " ") --Buffer's ID may be more than one digit, therefore using this function can be use to ensure that we won't get the truncated one
	if tokens[1]:sub(1, 1) ~= self.HOSTING_INDICATOR then -- if this true, it means that `tokens[1]` is buf'ID
		local buf_to_attach = tonumber(tokens[1])
		local buf_to_detach = vim.api.nvim_win_get_buf(host_winnr)

		if type(buf_to_attach) == "number" then
			self:highlightAttachedBufs(buf_to_attach, buf_to_detach)

			--return
			self.HOSTED_BUFS_DICT[buf_to_attach] = host_winnr
			self.HOSTED_BUFS_DICT[buf_to_detach] = false

			vim.api.nvim_win_set_buf(host_winnr, buf_to_attach)
		end
	else
		print("This buffer's already been  hosted by a window!")
	end
end

function M:unloadBuf()
	local tokens = utils.splitString(vim.api.nvim_get_current_line(), " ")
	if tokens[1]:sub(1, 1) ~= self.HOSTING_INDICATOR then
		local buf_to_unload = tonumber(tokens[1])
		if type(buf_to_unload) == "number" then
			vim.api.nvim_buf_delete(buf_to_unload, { unload = true })
			self.HOSTED_BUFS_DICT[buf_to_unload] = nil --remove unloaed buffer(key) from the dict-like table
		end
	else
		print("This buffer is being hosted by an active window!")
	end
	vim.api.nvim_del_current_line()
end

function M:init()
	local host_winnr = vim.api.nvim_get_current_win() --log previous cursor-stayed window before opening a floating window
	local scratch_bufnr = scratch_buffer.createMutableScratchBuf()

	self:getVerifiedBufs()
	self:findHostedBufs()

	vim.api.nvim_buf_set_lines(scratch_bufnr, 0, -1, true, self:formatOutput())
	utils:align2Words(scratch_bufnr, " ")
	--utils.openFloatingWindow(scratch_bufnr, utils.abbreviateHomeDir(vim.fn.getcwd()))
	minimal_floating_window.openFloatingWindow(scratch_bufnr, utils.abbreviateHomeDir(vim.fn.getcwd()))

	--#remap:
	--  <CR> to evoke the `switchBuf` function
	--  <CMD>q<CR> to `q` to shorten exit command
	--  dd to evoke `removeBuf` function
	--#
	vim.keymap.set("n", "<CR>", function()
		self:switchBuf(host_winnr)
	end, { buffer = scratch_bufnr, noremap = true })

	vim.keymap.set("n", "q", "<CMD>q<CR>", { buffer = scratch_bufnr, noremap = true })

	vim.keymap.set("n", "dd", function()
		self:unloadBuf()
	end, { buffer = scratch_bufnr, noremap = true })
end

return M
