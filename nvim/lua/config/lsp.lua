--# config LSPs
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- lua
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths
					-- here.
					"${3rd}/luv/library",
					-- '${3rd}/busted/library'
				},
			},
		})
	end,
	settings = {
		Lua = {},
	},
})
-- c/cpp
vim.lsp.config("clangd", {
	capabilities = capabilities,
})

--# enable LSPs
vim.lsp.enable({ "lua_ls", "clangd" })

-- keymaps
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
