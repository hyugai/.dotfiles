local set = vim.o
local keymap = vim.keymap

-- some options
set.autoindent = true
set.expandtab = true
set.number = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4

-- press 'a/i, A/I' after reopen the terminal to enter the "Terminal Mode"
keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>l", {})

-- rustacenvim
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

-- navigate windows
keymap.set("n", "<C-h>", ":wincmd h<CR>", { noremap = true }) -- left
keymap.set("n", "<C-j>", ":wincmd j<CR>", { noremap = true }) -- bot
keymap.set("n", "<C-k>", ":wincmd k<CR>", { noremap = true }) -- top
keymap.set("n", "<C-l>", ":wincmd l<CR>", { noremap = true }) -- right

-- docker-compose filetype detection
-- TODO: add regex to recognize any file has the pattern of "docker-compose.[something].yaml"
-- use "pattern" arg, shift + k -> "add" below for more info
vim.filetype.add({
    filename = {
        ["docker-compose.yml"] = "yaml.docker-compose",
        ["docker-compose.yaml"] = "yaml.docker-compose",
        ["compose.yml"] = "yaml.docker-compose",
        ["compose.yaml"] = "yaml.docker-compose",
    },
})
