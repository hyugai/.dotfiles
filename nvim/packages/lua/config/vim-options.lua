-- some options
vim.cmd("set autoindent")
vim.cmd("set expandtab")
vim.cmd("set number")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

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
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>') -- left
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>') -- bot 
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>') -- top
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>') -- right

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
