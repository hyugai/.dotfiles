local tree = {
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
						untracked = "★", -- this is often the "star" you’re seeing
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
return {
	tree,
}
