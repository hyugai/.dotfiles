local M = {}

---@type string
M.HOSTING_INDICATOR = "*"

---@type table<number, number|boolean>
M.HOSTED_BUFS_DICT = {}

local utils = require("switcher.utils")
--#

---3-level verification includes checking if a buf is VALID and LOADED and checking if it a FILE or not from its absolute path
---@param bufnr number
---@return number|nil
M.verifyBuf = function(bufnr)
	if vim.api.nvim_buf_is_loaded(bufnr) then -- loaded
		local bufInfo = vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr))
		if bufInfo and bufInfo.type == "file" then -- existing
			return bufnr
		end
	else
		return nil
	end
end

---Return all bufs passing the 3-level verification
M.getVerifiedBufs = function(self)
	for _, value in ipairs(vim.api.nvim_list_bufs()) do
		local bufnr = self.verifyBuf(value)
		if bufnr then
			--return
			self.HOSTED_BUFS_DICT[bufnr] = false --default value is false
		end
	end
end

---Get bufs' ID being hosted by windows
M.findHostedBufs = function(self)
	self:getVerifiedBufs()
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

---Get formated output for readable purpose: HOSTING_INDICATOR - BUF'S ID - BUF'S NAME
---@return table<string>
M.formatOutput = function(self)
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
M.switchBuf = function(self, host_winnr)
	local selected_line = vim.api.nvim_get_current_line()
	if selected_line:sub(1, 1) ~= self.HOSTING_INDICATOR then
		local buf_to_attach = tonumber(selected_line:sub(2, 2))
		local buf_to_detach = vim.api.nvim_win_get_buf(host_winnr)

		if type(buf_to_attach) == "number" then
			utils.highlightActiveInstance(buf_to_attach, buf_to_detach, vim.api.nvim_buf_get_lines(0, 0, -1, true))

			--return
			self.HOSTED_BUFS_DICT[buf_to_attach] = host_winnr
			self.HOSTED_BUFS_DICT[buf_to_detach] = false

			vim.api.nvim_win_set_buf(host_winnr, buf_to_attach)
		end
	end
end

M.init = function(self)
	self:findHostedBufs()
	local formatted_output = self:formatOutput()

    for _, value in ipairs(formatted_output) do
        print(value)
    end
end
M:init()

return M
