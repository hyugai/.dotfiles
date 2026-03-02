local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("texlab", {
	capabilities = capabilities,
	settings = {
		texlab = {
			chktex = { onOpenAndSave = true, onEdit = true }, --linter
			latexFormatter = "latexindent", --need explicitly specifying
			build = {
				onSave = true, --update PDF after saving edited tex file
				forwardSearchAfter = true, --auto-open PDF viewer
			},
			forwardSearch = {
				executable = "okular",
				args = {
					"--unique", --avoid opening new windows
					"file://%p#src:%l%f", --file:// prefix -> URI (Uniform Resource Identifier) -> standardize file path
				},
			},
		},
	},
})
