-- some options
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.number = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- press 'a/i, A/I' after reopen the terminal to enter the "Terminal Mode"
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>l", {})

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
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { noremap = true }) -- left
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { noremap = true }) -- bot 
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { noremap = true }) -- top
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { noremap = true }) -- right

-- docker-compose filetype detection
-- TODO: add regex to recognize any file has the pattern of "docker-compose.[something].yaml"
-- use "pattern" arg, shift + k -> "add" below for more info
vim.filetype.add({
    filename = {
        ["docker-compose.yml"] = "yaml.docker-compose",
        ["docker-compose.yaml"] = "yaml.docker-compose",
        ["compose.yml"] = "yaml.docker-compose",
        ["compose.yaml"] = "yaml.docker-compose",
    }
})
