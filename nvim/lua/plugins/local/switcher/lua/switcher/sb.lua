local M = {}
local utils = require("switcher.utils")

function M.create()
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("bufhidden", "hide", { buf = bufnr })
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
	vim.api.nvim_set_option_value("swapfile", false, { buf = bufnr })

	return bufnr
end

---@return table<integer, integer|false>
function M.listVerifiedBufIds()
	local res = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and utils.verifyFile(vim.api.nvim_buf_get_name(bufnr)) then
			res[bufnr] = false
		end
	end

	for _, winnr in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_is_valid(winnr) then
			res[vim.api.nvim_win_get_buf(winnr)] = winnr
		end
	end

	return res
end

return M
