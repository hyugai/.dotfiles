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
                    --lua
					null_ls.builtins.formatting.stylua,

                    --python
					require("none-ls.formatting.ruff"),
					require("none-ls.diagnostics.ruff"),

                    --bash
                    null_ls.builtins.formatting.shellharden,
                    null_ls.builtins.diagnostics.shellharden,
				},
			})
		end,
		keys = {
			{ "<leader>gf", vim.lsp.buf.format, {} },
		},
	},
}
