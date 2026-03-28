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
					"stylua",
					"clang-format",
					"shfmt",
					"shellcheck",
				},
			},
		},
	},
	opts = {
		ensure_installed = {
			"lua_ls",
			"clangd",
			"bashls",
			"ruff",
			"pyright",
			"texlab",
		},
	},
}
