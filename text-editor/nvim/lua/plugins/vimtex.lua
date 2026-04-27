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
		}
	end,
}
