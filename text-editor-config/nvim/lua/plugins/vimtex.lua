return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_view_general_viewer = "okular"
		vim.g.vimtex_view_general_options = "--unique --noraise file:@pdf#src:@line@tex"
		vim.g.vimtex_compiler_latexmk = {
			continuous = 1,
			aux_dir = "build",
			out_dir = "build",
			options = {
				"-shell-escape", -- run external programs (e.g. TikZ externalization)
				"-interaction=nonstopmode", -- keep compiling even if errors occur
				"-synctex=1", -- enable forward (.tex -> PDF) & inverse (PDF -> source .tex) search
			},
		}
	end,
}
