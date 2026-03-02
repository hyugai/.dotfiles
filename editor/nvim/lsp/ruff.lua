local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("ruff", {
	capabilities = capabilities,
	init_options = {
		settings = {
			unsafe_fixes = true,
		},
	},
})
