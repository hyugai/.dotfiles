return {
	[1] = "christoomey/vim-tmux-navigator",
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
	},
	keys = {
		{ "<C-h>", ":TmuxNavigateLeft<CR>" },
		{ "<C-j>", ":TmuxNavigateDown<CR>" },
		{ "<C-k>", ":TmuxNavigateUp<CR>" },
		{ "<C-l>", ":TmuxNavigateRight<CR>" },
		{ "<C-p>", ":TmuxNavigatePrevious<CR>" },
	},
}
