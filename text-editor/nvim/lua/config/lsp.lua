local capabilities = require("cmp_nvim_lsp").default_capabilities()

--lua
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
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

--latex
--vim.lsp.config("texlab", {
--	capabilities = capabilities,
--})

--c/cpp
vim.lsp.config("clangd", {
	capabilities = capabilities,
})

--bash
vim.lsp.config("bashls", {
	capabilities = capabilities,
})

--python
vim.lsp.config("ruff", {
	capabilities = capabilities,
})
vim.lsp.config("pyright", {
	capabilities = capabilities,
	on_attach = function(client, _)
		if client.name == "pyright" then
			client.handlers["textDocument/publishDiagnostics"] = function() end
		end
	end,
	settings = {
		pyright = {
			--ruff handles
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				--ruff handles
				ignore = { "*" },
			},
		},
	},
})

--vim.lsp.enable({ "lua_ls", "clangd", "bashls", "ruff", "pyright", "texlab" }, true)

--keymap
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
