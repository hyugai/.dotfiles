return {
	[1] = "stevearc/conform.nvim",
	dependencies = { "mason-org/mason.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
		},
	},
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format()
			end,
			{ desc = "Trigger formatter for current file" },
		},
	},
}
