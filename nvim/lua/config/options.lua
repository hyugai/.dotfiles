--general opts
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.mouse = ""

--nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_set_hl(0, "NvimTreeNormalFloatBorder", { fg = "#ADD8E6" })
vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#FFE599", bold = true })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#FFE599", bold = true })
vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#FBC02D" })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFile", { fg = "#61AFEF", bold = true })

--true colors supported (also 4-level colors for diagnostics)
vim.opt.termguicolors = true
