local M = {}

function M.create()
	local bufnr = vim.api.nvim_create_buf(false, false)
	vim.api.nvim_set_option_value("bufhidden", "hide", { buf = bufnr })
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
	vim.api.nvim_set_option_value("swapfile", false, { buf = bufnr })

	return bufnr
end

return M
