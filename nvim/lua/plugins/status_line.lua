return {
	[1] = "nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "auto",
			disabled_filetypes = {
				statusline = { "NvimTree" },
			},
		},
	},
}
