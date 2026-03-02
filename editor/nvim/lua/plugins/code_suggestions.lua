local icons = {
	Text = "󰉿",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
	Field = "󰜢",
	Variable = "󰀫",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "󰑭",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "󰈇",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "󰙅",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "",
}

return {
	[1] = "hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local cmp = require("cmp")

		cmp.setup({
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			},

			window = {
				completion = cmp.config.window.bordered({
					border = "none",
					winhighlight = "Normal:Pmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
				}),
				documentation = cmp.config.window.bordered({
					border = "single",
					winhighlight = "Normal:Normal,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
				}),
			},

			mapping = cmp.mapping.preset.insert({
				["<C-f>"] = cmp.mapping.scroll_docs(4), --scroll docs forward
				["<C-b>"] = cmp.mapping.scroll_docs(-4), --scroll docs backward
				["<CR>"] = cmp.mapping.confirm({ select = true }), --accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
			}),

			formatting = {
				fields = { "kind", "abbr", "menu" }, --order to display: icon, name, source
				format = function(entry, vim_item)
					vim_item.kind = icons[vim_item.kind] or ""
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						vsnip = "[Vsnip]",
						buffer = "[Buffer]",
						path = "[Path]",
					})[entry.source.name]

					return vim_item
				end,
			},

			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
			}, {
				{ name = "buffer" },
			}),

			completion = {
				completeopt = "menu,menuone",
			},
		})

		vim.api.nvim_set_hl(0, "Pmenu", { bg = "#2c3043", fg = "#c3ccdc" })
		vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#3b4261", fg = "NONE" })
		vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#2c3043" }) --static part (slide slot) where 'PmenuThumb' moves
		vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#454e6b" }) --moving vertical bar (slide)
	end,
}
