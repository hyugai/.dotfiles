return {
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.completion.spell,

                    null_ls.builtins.formatting.shellharden,
                    null_ls.builtins.diagnostics.shellharden,

					require("none-ls.formatting.ruff"),
					require("none-ls.diagnostics.ruff"),
				},
			})
		end,
		keys = {
			{ "<leader>gf", vim.lsp.buf.format, {} },
		},
	},
}
