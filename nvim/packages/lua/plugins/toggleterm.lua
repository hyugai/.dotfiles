return {
	{
		[1] = "akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<leader>tt", ":ToggleTerm<CR>", {} },
		},
		opts = {
			direction = "float",
			float_opts = {
				border = "curved",
			},
		},
	},
}
