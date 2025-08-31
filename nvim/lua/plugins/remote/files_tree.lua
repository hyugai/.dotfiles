local float_window = {
	opts = {
		relative = "editor",
		width = 0,
		height = 0,
		col = 0,
		row = 0,
		style = "minimal",
		border = "rounded",
	},
}
function float_window:setOpts(scale, editor, opts)
	if opts then
		for key, value in pairs(opts) do
			self.opts[key] = value
		end
	end

	self.opts.width = math.ceil(scale.width * editor.width)
	self.opts.height = math.ceil(scale.height * editor.height)
	self.opts.col = math.ceil(((1 - scale.width) / 2) * editor.width)

	return self
end

local nvim_tree = {
	[1] = "nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		view = {
			number = true,
			relativenumber = true,
			float = {
				enable = true,
				quit_on_focus_loss = false,
				open_win_config = float_window:setOpts(
					{ width = 0.5, height = 0.55 },
					{ width = vim.o.columns, height = vim.o.lines },
					{ title = "Files Tree", title_pos = "right" }
				).opts,
			},
		},
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
