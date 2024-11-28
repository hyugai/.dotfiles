return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	keys = {
		{ "<leader>gf", vim.lsp.buf.format, { desc = "Invoke formatter" } },
	},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				require("none-ls.formatting.ruff"),
				require("none-ls.diagnostics.ruff"),
			},
		})
	end,
}
