return {
	{
		[1] = "akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<leader>tt", ":ToggleTerm<CR>", {} },
		},
		opts = {
			direction = "horizontal",
			float_opts = {
				border = "curved",
			},
		},
	},
}
