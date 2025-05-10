return {
	{
		[1] = "nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
        opts = {
            auto_install = true,
        }
	},
}
