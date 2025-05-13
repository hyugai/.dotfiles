local M = {}
function M.setup(opts)
	vim.api.nvim_create_autocmd("VimResized", { callback = function()
        print("Hello, world")
    end })
end

return M
