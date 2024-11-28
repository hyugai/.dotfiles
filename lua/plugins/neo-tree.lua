return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    keys = {
        { "<C-n>", "<cmd>:Neotree filesystem reveal right<CR>", desc = "Reveal filesystem" },
        { "N",     "<cmd>:Neotree close<CR>",                   desc = "Close filesystem" },
    },
    opts = {
        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = false,
                never_show = { ".git", "__pycache__" },
            }
        }
    },
    config = true
}
