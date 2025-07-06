--styles = {
--  comments      = "italic" | "bold" | "underline" | "none",
--  functions     = "italic" | "bold" | "underline" | "none",
--  keywords      = "italic" | "bold" | "underline" | "none",
--  strings       = "italic" | "bold" | "underline" | "none",
--  variables     = "italic" | "bold" | "underline" | "none",
--  conditionals  = "italic" | "bold" | "underline" | "none",
--  constants     = "italic" | "bold" | "underline" | "none",
--  numbers       = "italic" | "bold" | "underline" | "none",
--  operators     = "italic" | "bold" | "underline" | "none",
--  types         = "italic" | "bold" | "underline" | "none",
--}

local github_nvim = {
	[1] = "projekt0n/github-nvim-theme",
	name = "github-theme",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("github-theme").setup({
			options = {
				transparent = false,
				styles = {
					comments = "italic",
					keywords = "bold",
					functions = "bold,italic",
					constants = "underline",
				},
			},
		})
		vim.cmd("colorscheme github_dark_default")
	end,
}

return github_nvim
