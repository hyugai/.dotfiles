return {
	{
		[1] = "mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
		config = function()
			local dap = require("dap")
			dap.configurations.rust = {}
		end,
	},
}
