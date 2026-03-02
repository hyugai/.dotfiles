return {
	[1] = "mason-org/mason-lspconfig.nvim", --LSPs
	dependencies = {
		"neovim/nvim-lspconfig",
		{
			[1] = "mason-org/mason.nvim", --Linters & Formatters
			opts = {
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
				ensure_installed = {
					"stylua", --lua formatter
					"clang-format", --c/cpp formatter
					"shfmt", --bash formatter
					"shellcheck", --bash linter
					"tex-fmt", --latex formatter
				},
			},
		},
	},
	opts = {
		ensure_installed = {
			"lua_ls", --lua
			"clangd", --c/cpp
			"bashls", --bash
			"ruff", --python
			"pyright", --python
			"texlab", --latex
		},
	},
}
