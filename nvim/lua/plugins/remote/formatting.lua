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
			python = {
				-- To fix auto-fixable lint errors.
				"ruff_fix",
				-- To run the Ruff formatter.
				"ruff_format",
				-- To organize the imports.
				"ruff_organize_imports",
			},
			tex = { "tex-fmt" }, -- "latexindent"
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
