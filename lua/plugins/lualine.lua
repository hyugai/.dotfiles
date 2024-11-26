--This plugin is used to customize the status line at the bottom
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			option = { theme = "bubbles" },
		})
	end,
}
