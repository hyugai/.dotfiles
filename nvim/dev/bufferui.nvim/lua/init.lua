local M = {}

function M.foo()
    local bufs = vim.cmd.ls()
    print(type(bufs))
end

function M.setup(opts)
    opts = opts or {}

    vim.keymap.set("n", "<leader>h", M.foo, { noremap = true })
end

return M
