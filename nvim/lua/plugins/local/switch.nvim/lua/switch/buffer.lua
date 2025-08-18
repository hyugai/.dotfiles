local float_toggle = require("switch.float_toggle")
local utils = require("switch.utils")
local M = {
	BUFFER = {
		---@type table<integer, integer|boolean>
		id_to_host_map = {},

		---@type integer
		id_max_length = 0,
	},
	WINDOW = {
		---@type integer
		id_host = nil,
	},
}

---@param total_lines integer
---@param n integer
function M._addLeftPadding(total_lines, n)
	for row_idx = 0, total_lines - 1, 1 do
		vim.api.nvim_buf_set_text(float_toggle.BUFFER.id_scratch, row_idx, 0, row_idx, 0, { (" "):rep(n) })
	end
end

---@param bufnr integer
---@param bufnr_max_length integer?
---@return string
function M:_formatLine(bufnr, bufnr_max_length)
	local length_diff = bufnr_max_length and bufnr_max_length - tostring(bufnr):len()
		or self.BUFFER.id_max_length - tostring(bufnr):len()

	return (" "):rep(length_diff + 1)
		.. tostring(bufnr)
		.. (self.BUFFER.id_to_host_map[bufnr] and "*" or " ")
		.. (" "):rep(2)
		.. utils.abbreviateHomeDir(vim.api.nvim_buf_get_name(bufnr):gsub(vim.fn.getcwd(), "."))
end

---@param row_idx integer --?:0-based index
---@param char string
function M:_updateHighlight(row_idx, char)
	vim.api.nvim_buf_set_text(
		float_toggle.BUFFER.id_scratch,
		row_idx,
		self.BUFFER.id_max_length + 1,
		row_idx,
		self.BUFFER.id_max_length + 2,
		{ char }
	)
end

---@return table<integer, integer|boolean>
---@return integer
function M:mapBufferToWindow()
	local res = {}
	local bufnr_max_length = 0

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			local buf_info, _, _ = vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr))
			if buf_info and (buf_info.type == "file") then
				res[bufnr] = false

				bufnr_max_length = bufnr_max_length >= tostring(bufnr):len() and bufnr_max_length
					or tostring(bufnr):len()
			end
		end
	end

	for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(winnr) then
			local bufnr = vim.api.nvim_win_get_buf(winnr)
			if vim.tbl_contains(vim.tbl_keys(res), bufnr) then --?:only allow verified buffers
				res[vim.api.nvim_win_get_buf(winnr)] = winnr
			end
		end
	end

	return res, bufnr_max_length
end

---@return table<integer, string>
function M:start()
	self.WINDOW.id_host = vim.api.nvim_get_current_win()
	self.BUFFER.id_to_host_map, self.BUFFER.id_max_length = self:mapBufferToWindow()

	local res = {}
	for bufnr, _ in pairs(self.BUFFER.id_to_host_map) do
		table.insert(res, self:_formatLine(bufnr))
	end

	return res
end

function M:update()
	local remained_bufnrs = {}
	local deleted_lines = 0
	local remained_lines = 0
	local bufnr_to_winnr_map, bufnr_max_length = self:mapBufferToWindow()

	--#delete old buffers && update highlights
	self.BUFFER.id_to_host_map = bufnr_to_winnr_map
	for idx, line in ipairs(vim.api.nvim_buf_get_lines(float_toggle.BUFFER.id_scratch, 0, -1, true)) do
		local row_idx = idx - deleted_lines - 1 --?: 0-based idx
		local bufnr = tonumber(line:match("(%d+)"))
		local host_flag = line:match("%*")

		if self.BUFFER.id_to_host_map[bufnr] == nil then
			vim.api.nvim_buf_set_lines(float_toggle.BUFFER.id_scratch, row_idx, row_idx + 1, true, {})

			deleted_lines = deleted_lines + 1
		else
			if self.BUFFER.id_to_host_map[bufnr] and not host_flag then --?:add "*"
				self:_updateHighlight(row_idx, "*")
			elseif not self.BUFFER.id_to_host_map[bufnr] and host_flag then --?:remove "*"
				self:_updateHighlight(row_idx, " ")
			end

			table.insert(remained_bufnrs, bufnr)
			remained_lines = remained_lines + 1
		end
	end
	--#endregion

	--#add additional left paddings if one of the new buffers' legths exceeds previous one
	local extra_padding = bufnr_max_length - self.BUFFER.id_max_length
	if extra_padding > 0 then
		self._addLeftPadding(remained_lines, extra_padding)
	end
	--#endregion

	--#insert new buffers
	self.BUFFER.id_max_length = bufnr_max_length
	for bufnr, _ in pairs(bufnr_to_winnr_map) do
		if not vim.tbl_contains(remained_bufnrs, bufnr) then
			vim.api.nvim_buf_set_lines(float_toggle.BUFFER.id_scratch, -1, -1, true, {
				self:_formatLine(bufnr, bufnr_max_length),
			})
		end
	end
	--#
end

function M:switch()
	local lines = vim.api.nvim_buf_get_lines(float_toggle.BUFFER.id_scratch, 0, -1, true)

	local bufnr_to_detach = vim.api.nvim_win_get_buf(self.WINDOW.id_host)
	for index, line in ipairs(lines) do
		local row_idx = index - 1
		local bufnr = tonumber(line:match("(%d+)"))
		if bufnr == bufnr_to_detach and bufnr then
			self:_updateHighlight(row_idx, " ")
			break
		end
	end

	local current_row_pos = vim.api.nvim_win_get_cursor(float_toggle.WINDOW.id_float)[1] --?:0-based index
	local bufnr_to_attach = tonumber(lines[current_row_pos]:match("(%d+)"))
	if bufnr_to_attach then
		self:_updateHighlight(current_row_pos - 1, "*")
		self.BUFFER.id_to_host_map[bufnr_to_attach] = self.WINDOW.id_host
		vim.api.nvim_win_set_buf(self.WINDOW.id_host, bufnr_to_attach)
	end
end

function M:toggle()
	if not float_toggle.BUFFER.id_scratch then
		local lines = self:start()
		float_toggle:open(
			{ height = 0.4, width = 0.45 },
			{ height = vim.o.lines, width = vim.o.columns },
			{ title = "Buffer Switcher", title_pos = "center" },
			lines
		)
		vim.api.nvim_win_set_hl_ns(float_toggle.WINDOW.id_float, vim.api.nvim_create_namespace("switch.nvim"))
	elseif not float_toggle.WINDOW.id_float or not vim.api.nvim_win_is_valid(float_toggle.WINDOW.id_float) then --?:`BUFFER.id_scratch` avail, WINDOW.id_floating not avail or not valid
		float_toggle:reOpen(function()
			self:update()
		end)
	else
		float_toggle:hide() --?:both `BUFFER.id_scratch` and `WINDOW.id_floating` are avail
	end
end

return M
