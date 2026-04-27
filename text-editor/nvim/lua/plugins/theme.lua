local github_nvim = {
	[1] = "projekt0n/github-nvim-theme",
	name = "github-theme",
	lazy = false, --make sure we load this during startup if it is your main colorscheme
	priority = 1000, --make sure to load this before all the other start plugins
	config = function()
		require("github-theme").setup({
			groups = {
				all = {
					Normal = { bg = "#181818" },
					EndOfBuffer = { fg = "#181818" },
					CursorLine = { bg = "#181818" },
					NormalFloat = { bg = "NONE" }, --`NONE` -> transparent
					SignColumn = { bg = "NONE" },

					NormalNC = { bg = "#121212" }, --`NC` stands for "Non Current" -> inacitve window
				},
			},
			options = {
				transparent = false,
				styles = {
					comments = "italic",
				},
			},
		})
		vim.cmd("colorscheme github_dark_colorblind")
	end,
}

return github_nvim
