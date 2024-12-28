return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({})
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ruff",
					"pyright",
					"rust_analyzer",
					"bashls",
				},
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			--lua
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			--python
			lspconfig.pyright.setup({
				capabilities = capabilities,
				settings = {
					pyright = {
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							ignore = { "*" },
						},
					},
				},
			})
			lspconfig.ruff.setup({
				capabilities = capabilities,
			})

			--bash
			lspconfig.bashls.setup({
				capabilities = capabilities,
			})
		end,
		keys = {
			{ "K", vim.lsp.buf.hover, {} },
			{ "<leader>ca", vim.lsp.buf.code_action, {} },
		},
	},
}
