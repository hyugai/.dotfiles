local function setWinOpts()
	return {
		relative = "editor",
		width = math.ceil(vim.opt.columns:get() * 0.5), --magnitude: X
		height = math.ceil(vim.opt.lines:get() * 0.5), --magnitude: Y
		col = ((1 - 0.5) / 2) * vim.opt.columns:get(), --cordinate: X
		row = 0, --cordinate: Y
		style = "minimal",
		border = "single",
		--title = "Files Tree",
		--title_pos = "right",
	}
end
local nvim_tree = {
	[1] = "nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		view = {
			signcolumn = "no",
			number = false,
			relativenumber = false,
			float = {
				enable = true,
				quit_on_focus_loss = true, --close popped-up window after entering selected file
				open_win_config = setWinOpts, --pass function instead of value
			},
		},
		git = {
			enable = true,
			ignore = false,
		},
		update_focused_file = {
			enable = true,
		},
		renderer = {
			highlight_opened_files = "name",
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
		--{ "to", "<CMD>NvimTreeOpen<CR>", { noremap = true } },
		--{ "tc", "<CMD>NvimTreeClose<CR>", { noremap = true } },
		{ "<C-n>", "<CMD>NvimTreeToggle<CR>", { noremap = true } },
	},
}

local telescope = {
	[1] = "nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>ff", "<CMD>Telescope find_files<CR>", {} },
	},
}

return {
	nvim_tree,
	telescope,
}
