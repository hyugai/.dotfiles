return {
	[1] = "mason-org/mason-lspconfig.nvim", -- LSPs
	dependencies = {
		"neovim/nvim-lspconfig",
		{
			[1] = "mason-org/mason.nvim", -- Linters and Formatters
			opts = {
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
				ensure_installed = {
					"stylua", -- lua
					--"selene", -- lua
				},
			},
		},
	},
	opts = {
		ensure_installed = {
			"lua_ls", -- lua
		},
	},
}
