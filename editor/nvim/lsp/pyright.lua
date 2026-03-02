local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("pyright", {
	capabilities = capabilities,
	on_attach = function(client, _) --change value(function object) of the key `textDocument/publishDiagnostics`
		if client.name == "pyright" then
			client.handlers["textDocument/publishDiagnostics"] = function() end
		end
	end,
	settings = {
		pyright = {
			--use ruff's import organizer
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				--ignore all files for analysis to exclusively use Ruff for linting
				ignore = { "*" },
			},
		},
	},
})
