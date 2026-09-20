-- lua/config/bufferline.lua
-- Use `:source %` to reload this file.

local severity = vim.diagnostic.severity

local ERROR = severity.ERROR
local WARN = severity.WARN
local INFO = severity.INFO
local HINT = severity.HINT

local colors = require("ui.colors")
local signs = require("ui.signs")

local BufferLine = {}

-- ============================================================================
-- Configuration
-- ============================================================================

local diagnostic_signs = {
	[ERROR] = signs.linter.Error,
	[WARN] = signs.linter.Warn,
	[INFO] = signs.linter.Info,
	[HINT] = signs.linter.Hint,
}

local diagnostic_highlights = {
	[ERROR] = "MyBufferLineError",
	[WARN] = "MyBufferLineWarn",
	[INFO] = "MyBufferLineInfo",
	[HINT] = "MyBufferLineHint",
}

local diagnostic_order = {
	ERROR,
	WARN,
	INFO,
	HINT,
}

-- ============================================================================
-- Highlights
-- ============================================================================

local function setup_highlights()
	local buffer_colors = colors.buffer_line
	local linter_colors = colors.linter

	vim.api.nvim_set_hl(0, "MyBufferLine", {
		fg = buffer_colors.MossyGreen,
		bg = buffer_colors.DarkGrey,
		italic = true,
	})

	vim.api.nvim_set_hl(0, "MyBufferLineSel", {
		fg = buffer_colors.Black,
		bg = buffer_colors.MossyGreen,
		bold = true,
	})

	vim.api.nvim_set_hl(0, "MyBufferLineSep", {
		fg = buffer_colors.White,
		bg = buffer_colors.DarkGrey,
		bold = true,
	})

	vim.api.nvim_set_hl(0, "MyBufferLineError", {
		fg = linter_colors.Error,
		bg = buffer_colors.MossyGreen,
		bold = true,
	})

	vim.api.nvim_set_hl(0, "MyBufferLineWarn", {
		fg = linter_colors.Warn,
		bg = buffer_colors.MossyGreen,
		bold = true,
	})

	vim.api.nvim_set_hl(0, "MyBufferLineInfo", {
		fg = linter_colors.Info,
		bg = buffer_colors.MossyGreen,
		bold = true,
	})

	vim.api.nvim_set_hl(0, "MyBufferLineHint", {
		fg = linter_colors.Hint,
		bg = buffer_colors.MossyGreen,
		bold = true,
	})
end

-- ============================================================================
-- Helpers
-- ============================================================================

local function is_active(bufnr)
	return #vim.fn.win_findbuf(bufnr) > 0
end

local function get_buffer_name(buf)
	if buf.name == "" then
		return "[No Name]"
	end

	local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	local buf_dir = vim.fn.fnamemodify(buf.name, ":h:t")

	local name

	if cwd == buf_dir then
		name = vim.fn.fnamemodify(buf.name, ":t")
	else
		name = vim.fn.pathshorten(vim.fn.fnamemodify(buf.name, ":."))
	end

	-- Escape `%` because it has special meaning in 'tabline'.
	return name:gsub("%%", "%%%%")
end

local function render_diagnostics(bufnr)
	local parts = {}
	local counts = vim.diagnostic.count(bufnr)

	for _, severity_level in ipairs(diagnostic_order) do
		local count = counts[severity_level] or 0

		if count > 0 then
			parts[#parts + 1] = string.format(
				"%%#%s#%s (%d) ",
				diagnostic_highlights[severity_level],
				diagnostic_signs[severity_level],
				count
			)
		end
	end

	return table.concat(parts)
end

-- ============================================================================
-- Bufferline
-- ============================================================================

function BufferLine.render()
	local parts = {}
	local buffers = vim.fn.getbufinfo({ buflisted = 1 })

	for index, buf in ipairs(buffers) do
		local active = is_active(buf.bufnr)

		-- Active / inactive buffer.
		parts[#parts + 1] = active and "%#MyBufferLineSel#" or "%#MyBufferLine#"

		-- Buffer name / click to open.
		parts[#parts + 1] = string.format("%%%d@v:lua.myBufferLineClickToOpen@ %s%%X", buf.bufnr, get_buffer_name(buf))

		-- Modified indicator / click to close.
		local close_icon = buf.changed == 1 and "  " or " x "

		parts[#parts + 1] = string.format("%%%d@v:lua.myBufferLineClickToClose@%s%%X", buf.bufnr, close_icon)

		-- Show diagnostics only for visible buffers.
		if active then
			parts[#parts + 1] = render_diagnostics(buf.bufnr)
		end

		-- Separator.
		if index < #buffers then
			parts[#parts + 1] = "%#MyBufferLineSep#|"
		end
	end

	parts[#parts + 1] = "%#MyBufferLine#"

	return table.concat(parts)
end

-- ============================================================================
-- Mouse actions
-- ============================================================================

function BufferLine.open(bufnr, _, button, _)
	if button ~= "l" then
		return
	end

	if vim.api.nvim_get_current_buf() == bufnr then
		return
	end

	vim.api.nvim_win_set_buf(0, bufnr)
end

function BufferLine.close(bufnr, _, button, _)
	if button ~= "l" then
		return
	end

	if vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
		vim.notify("Buffer has unsaved changes.", vim.log.levels.WARN)
		return
	end

	vim.api.nvim_buf_delete(bufnr, { force = false })
end

-- ============================================================================
-- Setup
-- ============================================================================

setup_highlights()

local group = vim.api.nvim_create_augroup("MyBufferLine", { clear = true })

vim.api.nvim_create_autocmd({
	"DiagnosticChanged",
	"BufAdd",
	"BufDelete",
	"BufModifiedSet",
	"BufEnter",
	"DirChanged",
}, {
	group = group,
	callback = function()
		vim.schedule(function()
			vim.cmd.redrawtabline()
		end)
	end,
})

vim.keymap.set("n", "<M-f>", "<cmd>bnext<cr>", {
	desc = "Next buffer",
})

vim.keymap.set("n", "<M-b>", "<cmd>bprevious<cr>", {
	desc = "Previous buffer",
})

_G.myBufferLine = BufferLine.render
_G.myBufferLineClickToOpen = BufferLine.open
_G.myBufferLineClickToClose = BufferLine.close

vim.o.tabline = "%!v:lua.myBufferLine()"
vim.o.showtabline = 2
