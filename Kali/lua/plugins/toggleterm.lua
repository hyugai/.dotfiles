return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<C-\\>", "<cmd>:ToggleTerm<CR>", {} },
		},
		opts = {
			direction = "float",
			float_opts = {
				border = "curved",
			},
		},
	},
}
