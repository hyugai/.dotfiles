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
				"ruff_fix", --fix auto-fixable lint errors.
				"ruff_format", --run the Ruff formatter.
				"ruff_organize_imports", --organize the imports.
			},
			tex = { "tex-fmt" }, --others: 'latexindent'
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
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
