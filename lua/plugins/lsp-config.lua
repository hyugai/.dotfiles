return {
    --mason
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    --mason-lspconfig
    --add "language server protocal" (e.g lua (language) -> lua_ls (lsp)
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright", "ruff" },
            })
        end,
    },

    --lspconfig
    {
        "neovim/nvim-lspconfig",
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

            --key-bindings
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },
}

