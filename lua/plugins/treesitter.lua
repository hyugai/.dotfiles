return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
        ensure_installed = { "lua", "javascript", "python" },
        highlight = { enable = true },
        indent = { enable = true },
        auto_installed = true,
    },
    config = true
}
