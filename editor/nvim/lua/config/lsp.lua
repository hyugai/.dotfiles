vim.lsp.enable({ "lua_ls", "clangd", "bashls", "ruff", "pyright", "texlab" }) --discover and start LSPs automatically

vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
