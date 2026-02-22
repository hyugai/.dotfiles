--use `:source` to run this file
local error = vim.diagnostic.severity.ERROR
local warn = vim.diagnostic.severity.WARN
local hint = vim.diagnostic.severity.HINT
local info = vim.diagnostic.severity.INFO

local colors = {}
colors[error] = "#fb4934" -- "#f85149"
colors[warn] = "#fabd2f" --"#d29922"
colors[hint] = "#5a5f66"
colors[info] = "#076678"
colors.mossy_green = "#8fa15e" --gruvbox
colors.dark_grey = "#1d2021" --gruvbox
colors.black = "#000000"
colors.white = "#ffffff"

local signs = {}
signs[error] = "✘"
signs[warn] = "▲"
signs[hint] = "⚑"
signs[info] = "»"

vim.api.nvim_set_hl(0, "MyTabLine", { fg = colors.mossy_green, bg = colors.dark_grey, italic = true })
vim.api.nvim_set_hl(0, "MyTabLineSel", { fg = colors.black, bg = colors.mossy_green, bold = true })
vim.api.nvim_set_hl(0, "MyTabLineSep", { fg = colors.white, bg = colors.dark_grey, bold = true })
vim.api.nvim_set_hl(0, "MyTabLineError", { fg = colors[error], bg = colors.mossy_green })
vim.api.nvim_set_hl(0, "MyTabLineWarn", { fg = colors[warn], bg = colors.mossy_green })
vim.api.nvim_set_hl(0, "MyTabLineHint", { fg = colors[hint], bg = colors.mossy_green })
vim.api.nvim_set_hl(0, "MyTabLineInfo", { fg = colors[info], bg = colors.mossy_green })

local TabLine = {}
function TabLine.init()
	--`%`: escape character (start)
	--`%#{Hightlight Group}#{Text}`
	--`%{Id}@v:lua.{Global Function}@{Text}%X`
	local s = {}
	local bufs = vim.fn.getbufinfo({ buflisted = 1 })
	for idx, buf in ipairs(bufs) do
		--highlight `active` or `inactive`
		local is_active = #vim.fn.win_findbuf(buf.bufnr) > 0 and "%#MyTabLineSel#" or "%#MyTabLine#"
		s[#s + 1] = is_active

		--name / open
		local buf_name = vim.fn.fnamemodify(buf.name, ":t")
		local click_to_open = "%"
			.. buf.bufnr
			.. "@v:lua.myTabLineClickToOpen@"
			.. (buf_name == "" and " [No Name]" or " " .. buf_name)
			.. "%X"
		s[#s + 1] = click_to_open

		--save or unsaved / close
		local is_saved = buf.changed == 1 and "  " or " x " --`1`: there're UNSAVED changes
		local click_to_close = "%" .. buf.bufnr .. "@v:lua.myTabLineClickToClose@" .. is_saved .. "%X"
		s[#s + 1] = click_to_close

		--diagnostics stats
		if #vim.fn.win_findbuf(buf.bufnr) > 0 then
			local diagnosticStats = TabLine.getDiagnosticStats(buf.bufnr)
			for severity, count in pairs(diagnosticStats) do
				if count > 0 then
					if severity == error then
						s[#s + 1] = "%#MyTabLineError#" .. signs[severity] .. ":" .. count .. " "
					elseif severity == warn then
						s[#s + 1] = "%#MyTabLineWarn#" .. signs[severity] .. ":" .. count .. " "
					elseif severity == hint then
						s[#s + 1] = "%#MyTabLineHint#" .. signs[severity] .. ":" .. count .. " "
					else
						s[#s + 1] = "%#MyTabLineInfo#" .. signs[severity] .. ":" .. count .. " "
					end
				end
			end
		end

		--separator
		if idx < #bufs then
			s[#s + 1] = "%#MyTabLineSep#|"
		end

		--reset color
		s[#s + 1] = "%#MyTabLine#"
	end

	return table.concat(s)
end
function TabLine.clickToOpen(id, _, button, _)
	if button == "l" then
		local current_buf = vim.api.nvim_get_current_buf()
		if current_buf ~= id then
			local current_win = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_buf(current_win, id)
		end
	end
end
function TabLine.clickToClose(id, _, button, _)
	if button == "l" then
		--print(vim.api.nvim_get_option_value("modified", { buf = id }))
		if vim.api.nvim_get_option_value("modified", { buf = id }) then
			vim.notify("[WARN]: Unsaved changes!!!\n\n", vim.log.levels.WARN)
		else
			vim.api.nvim_buf_delete(id, { force = true })
		end
	end
end
function TabLine.getDiagnosticStats(buf)
	local res = {}
	res[error] = vim.diagnostic.count(buf, { severity = error })[error] or 0
	res[warn] = vim.diagnostic.count(buf, { severity = warn })[warn] or 0
	res[hint] = vim.diagnostic.count(buf, { severity = hint })[hint] or 0
	res[info] = vim.diagnostic.count(buf, { severity = info })[info] or 0

	return res
end

vim.api.nvim_create_autocmd({ "InsertLeave", "DiagnosticChanged" }, {
	callback = function(_)
		vim.cmd("redrawtabline")
	end,
})

_G.myTabLine = TabLine.init
_G.myTabLineClickToOpen = TabLine.clickToOpen
_G.myTabLineClickToClose = TabLine.clickToClose
vim.o.tabline = "%!v:lua.myTabLine()"
vim.o.showtabline = 2 --see :help 'showtabline'
