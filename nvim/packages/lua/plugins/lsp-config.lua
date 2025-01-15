return {
	{
		[1] = "williamboman/mason.nvim",
		opts = {},
	},

	{
		[1] = "williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"ruff",
				"pyright",
				"rust_analyzer",
				"bashls",
				"clangd",
			},
		},
	},

	{
		[1] = "neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			--lua
			local lua_lsp_settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim", "require" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
					telemetry = {
						enable = false,
					},
				},
			}
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = lua_lsp_settings,
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

			--c/cpp
			lspconfig.clangd.setup({
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--fallback-style=webkit",
				},
			})
		end,
		keys = {
			{ "K", vim.lsp.buf.hover, {} },
			{ "<leader>ca", vim.lsp.buf.code_action, {} },
		},
	},
}
