return {
	[1] = "nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	opts = {
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
		auto_install = true,
	},
}
