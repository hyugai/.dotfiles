local nvim_tree = {
	[1] = "nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		git = {
			enable = true,
			ignore = false,
		},
		renderer = {
			icons = {
				glyphs = {
					folder = {
						arrow_closed = " ▶",
						arrow_open = " ▼",
					},
					git = {
						unstaged = "✗",
						staged = "✓",
						unmerged = "",
						renamed = "➜",
						untracked = "★",
						deleted = "",
						ignored = "◌",
					},
				},
			},
		},
	},
	keys = {
		{ "to", ":NvimTreeOpen<CR>", { noremap = true } },
		{ "tc", ":NvimTreeClose<CR>", { noremap = true } },
	},
}

local telescope = {
	[1] = "nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>ff", ":Telescope find_files<CR>", {} },
	},
}

return {
	nvim_tree,
	telescope,
}
