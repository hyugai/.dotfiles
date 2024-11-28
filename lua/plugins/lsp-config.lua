return {
    --mason
    {
        "williamboman/mason.nvim",
        opts = {},
        config = true
    },

    --mason-lspconfig
    --add "language server protocal" (e.g lua (language) -> lua_ls (lsp)
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "lua_ls", "pyright", "ruff" },
        },
        config = true
    },

    --lspconfig
    {
        "neovim/nvim-lspconfig",
        keys = {
            { "K",          vim.lsp.buf.hover,       {} },
            { "gd",         vim.lsp.buf.definition,  {} },
            { "<leader>ca", vim.lsp.buf.code_action, {} },
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require("lspconfig")

            --adding LSP
            --lua
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
            --python: pyright
            lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                    pyright = { disableOrganizeImports = true },
                    python = {
                        analysis = { ignore = { "*" } },
                    },
                },
            })
            --python: ruff
            lspconfig.ruff.setup({
                capabilities = capabilities,
            })
        end,
    },
}
