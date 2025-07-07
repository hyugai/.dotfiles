local utils = require("switcher.utils")

---@class M
local M = {
	---@type string
	HOSTING_INDICATOR = "*",

	---buf'ID(key): host window'ID or false as default(value)
	---@type table<number, number|boolean>
	HOSTED_BUFS_DICT = {},
}

--3-level verification includes checking if a buf is VALID and LOADED and checking if it a FILE or not from its absolute path
---@param bufnr number
---@return number|nil
function M.verifyBuf(bufnr)
	if vim.api.nvim_buf_is_loaded(bufnr) then --VALID & LOADED
		local bufInfo = vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr))
		if bufInfo and bufInfo.type == "file" then --FILE
			return bufnr
		end
	else
		return nil
	end
end

---Get all bufs passing the 3-level verification
function M:getVerifiedBufs()
	for _, value in ipairs(vim.api.nvim_list_bufs()) do
		local bufnr = self.verifyBuf(value)
		if bufnr then
			--return
			self.HOSTED_BUFS_DICT[bufnr] = false --default or initial value is false
		end
	end
end

---Find bufs' ID being hosted by windows
function M:findHostedBufs()
	for _, value in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(value) then
			local bufnr = self.verifyBuf(vim.api.nvim_win_get_buf(value))
			if bufnr then
				--return
				self.HOSTED_BUFS_DICT[bufnr] = value
			end
		end
	end
end

---Format output for readable purpose: HOSTING_INDICATOR - BUF'S ID - BUF'S NAME
---@return table<string>
function M:formatOutput()
	local res_list = {}
	for key, value in pairs(self.HOSTED_BUFS_DICT) do
		local path = string.gsub(vim.api.nvim_buf_get_name(key), vim.fn.getcwd(), ".")
		local hosting_indicator = value and "*" or " " -- single line if-else
		table.insert(res_list, hosting_indicator .. tostring(key) .. " " .. path)
	end

	return res_list
end

---Triggered when hit `Enter` while in the popup window
---@param host_winnr number
function M:switchBuf(host_winnr)
	local tokens = utils.splitString(vim.api.nvim_get_current_line(), " ") --Buffer's ID may be more than one digit, therefore using this function can be use to ensure that we won't get the truncated one
	if tokens[1]:sub(1, 1) ~= self.HOSTING_INDICATOR then
		local buf_to_attach = tonumber(tokens[1]:sub(1, -1))
		local buf_to_detach = vim.api.nvim_win_get_buf(host_winnr)

		if type(buf_to_attach) == "number" then
			utils.highlightActiveInstance(buf_to_attach, buf_to_detach, vim.api.nvim_buf_get_lines(0, 0, -1, true))
			--return
			self.HOSTED_BUFS_DICT[buf_to_attach] = host_winnr
			self.HOSTED_BUFS_DICT[buf_to_detach] = false

			vim.api.nvim_win_set_buf(host_winnr, buf_to_attach) --need OUTSIDE data
		end
	else
		print("This buffer's already been  hosted by a window!")
	end
end

function M:init()
	local host_winnr = vim.api.nvim_get_current_win()
	local scratch_bufnr = utils.createScratchBuf()

	self:getVerifiedBufs()
	self:findHostedBufs()

	vim.api.nvim_buf_set_lines(scratch_bufnr, 0, -1, true, self:formatOutput())
	utils.openFloatingWindow(scratch_bufnr, vim.fn.getcwd())

	vim.keymap.set("n", "<CR>", function()
		self:switchBuf(host_winnr)
	end, { buffer = scratch_bufnr, noremap = true })
	vim.keymap.set("n", "q", "<CMD>q<CR>", { buffer = scratch_bufnr, noremap = true })
end

return M
