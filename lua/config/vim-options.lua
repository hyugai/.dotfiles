vim.cmd("set autoindent")
vim.cmd("set expandtab")
vim.cmd("set number")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

--press 'a, A' after reopen the terminal to enter the "Terminal Mode"
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>l", {})
--rustacenvim
vim.g.rustaceanvim = {
    default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
        },
    },
}
