return {
	-- #
	{
		[1] = "williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				-- linter
				"selene", -- lua
				"shellcheck", -- bash
				-- formatter
				"clang-format", --c/cpp
				"stylua", -- lua
				"shfmt", -- bash
				-- both
				"ruff", -- python
			},
		},
	},

	-- #
	{
		[1] = "williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls", -- lua
				"ruff", -- python
				"pyright", -- python
				"rust_analyzer", -- rust
				"bashls", -- bash
				"clangd", -- c/cpp
			},
		},
	},

	-- #
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
						globals = { "vim" },
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
					"--fallback-style=llvm",
				},
			})

			--rust
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				cmd = {
					"rustup",
					"run",
					"stable",
					"rust-analyzer",
				},
				settings = {
					["rust-analyzer"] = {
						checkOnSave = true,
						check = { command = "clippy", features = "all" },
						assist = {
							importGranularity = "module",
							importPrefix = "self",
						},
						diagnostics = {
							enable = true,
							enableExperimental = true,
						},
						cargo = {
							loadOutDirsFromCheck = true,
							features = "all", -- avoid error: file not included in crate hierarchy
						},
						procMacro = {
							enable = true,
						},
						inlayHints = {
							chainingHints = true,
							parameterHints = true,
							typeHints = true,
						},
					},
				},
			})

		end,
		keys = {
			{ "K", vim.lsp.buf.hover, {} },
			{ "<leader>ca", vim.lsp.buf.code_action, {} },
		},
	},
}
