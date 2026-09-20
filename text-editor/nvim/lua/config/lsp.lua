local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
	capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
	on_init = function(client)
		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					"${3rd}/luv/library",
				},
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

vim.lsp.config("roslyn_ls", {})
vim.lsp.config("texlab", {})
vim.lsp.config("vtsls", {})
vim.lsp.config("clangd", {})
vim.lsp.config("bashls", {})
vim.lsp.config("pyright", {})
vim.lsp.config("lemminx", {})

vim.lsp.enable({
	"lua_ls",
	"clangd",
	"bashls",
	"pyright",
	"texlab",
	"roslyn_ls",
	"vtsls",
	"lemminx",
})
