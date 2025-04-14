return {
    {
        [1] = "nvimtools/none-ls.nvim",
        dependencies = {
            "nvimtools/none-ls-extras.nvim",
        },
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    --lua
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.diagnostics.selene,

                    --python
                    require("none-ls.formatting.ruff"),
                    require("none-ls.diagnostics.ruff"),

                    --[[bash
                    no need to call ""null_ls.builtins.diagnostics.shellcheck"
                    --]]
                    null_ls.builtins.formatting.shfmt,

                    --c/cpp
                    null_ls.builtins.formatting.clang_format,
                },
            })
        end,
        keys = {
            { "<leader>gf", vim.lsp.buf.format, { noremap = true } },
        },
    },
}
