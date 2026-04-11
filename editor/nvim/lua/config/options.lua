--general
vim.o.autoindent = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.mouse = "n" --see :help 'mouse'
vim.o.termguicolors = true --see :help 'termguicolors'
vim.o.laststatus = 0 --see :help 'laststatus'

--relative line's number
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff9e64", bold = true })
vim.opt.wildignore:append({
	-- git
	"*/.git/*",
	-- python
	"*/__pycache__/*",
	"*.pyc",
	"*/venv/*",
	"*/.venv/*",
	"*/build/*",
	"*/dist/*",
	-- c/c++
	"*.o",
	"*.obj",
	"*.so",
	"*.a",
	"*/build/*",
	--latex
	"*.aux",
	"*.log",
	"*.out",
	"*.toc",
	"*.fdb_latexmk",
	"*.fls",
	"*.synctex.gz",
	"*.pdf",
	"*.blg",
	"*.bbl",
	"*.nav",
	"*.snm",
})
