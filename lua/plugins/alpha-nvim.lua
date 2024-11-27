--This plugin is used to customize the "welcome" dashboard
return {
	"goolord/alpha-nvim",
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		require("alpha").setup(require("alpha.themes.startify").config)
	end,
}
