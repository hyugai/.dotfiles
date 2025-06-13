return {
	[1] = "projekt0n/github-nvim-theme",
	name = "github-theme",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("github-theme").setup({
			options = {
				styles = {
					comments = "italic",
					functions = "bold",
					keywords = "italic,bold",
					conditionals = "italic",
					constants = "bold",
					types = "italic",
				},
				transparent = true,
			},
		})

		vim.cmd("colorscheme github_dark_colorblind")
	end,
}
