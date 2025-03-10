local set = vim.o
local keymap = vim.keymap

--# neovim's options
set.autoindent = true
set.expandtab = true
set.number = true
set.relativenumber = true
set.cursorline = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4

--# press 'a/i, A/I' after reopen the terminal to enter the "Terminal Mode"
keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>l", {})

--# navigate windows
keymap.set("n", "<C-h>", ":wincmd h<CR>", { noremap = true }) -- left
keymap.set("n", "<C-j>", ":wincmd j<CR>", { noremap = true }) -- bot
keymap.set("n", "<C-k>", ":wincmd k<CR>", { noremap = true }) -- top
keymap.set("n", "<C-l>", ":wincmd l<CR>", { noremap = true }) -- right
