return {
	[1] = "stevearc/conform.nvim",
	dependencies = { "mason-org/mason.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			sh = { "shfmt" },
		},
	},
	keys = {
		{
			"<leader>fm",
			function()
				require("conform").format()
			end,
			{ desc = "Trigger formatter for current file" },
		},
	},
}
