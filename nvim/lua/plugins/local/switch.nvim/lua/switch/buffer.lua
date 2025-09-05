local utils = require("switch.utils")
local M = {
	BUFFER = {
		ids_to_unload = {},
	},
}

--#SUPPORTING methods: _addLeftPadding, _formatLine, _changeFlag,
--#MAIN methods: toggle (mapBufferToWindow, start, update), unloadBuf

M.float = require("switch.toggle_float"):new()
M.float.BUFFER.bufnr_to_winnr_map = {}
M.float.BUFFER.id_max_length = 0

M.float.WINDOW.id_host = nil

---@param total_lines integer
---@param n integer
function M:_addLeftPadding(total_lines, n)
	for row_idx = 0, total_lines - 1, 1 do
		vim.api.nvim_buf_set_text(self.float.BUFFER.id_scratch, row_idx, 0, row_idx, 0, { (" "):rep(n) })
	end
end

---@param bufnr integer
---@param bufnr_max_length integer?
---@return string
function M:_formatLine(bufnr, bufnr_max_length)
	local length_diff = bufnr_max_length and bufnr_max_length - tostring(bufnr):len()
		or self.float.BUFFER.id_max_length - tostring(bufnr):len()

	return (" "):rep(length_diff + 1)
		.. tostring(bufnr)
		.. (self.float.BUFFER.id_to_host_map[bufnr] and "*" or " ")
		.. (" "):rep(2)
		.. utils.abbreviateHomeDir(vim.api.nvim_buf_get_name(bufnr):gsub(vim.fn.getcwd(), "."))
end

---@param row_idx integer --?:0-based index
---@param flag string
function M:_changeFlag(row_idx, flag) --?: "*" means being hosted by a window, while " " is on other hand
	vim.api.nvim_buf_set_text(
		self.float.BUFFER.id_scratch,
		row_idx,
		self.float.BUFFER.id_max_length + 1,
		row_idx,
		self.float.BUFFER.id_max_length + 2,
		{ flag }
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
			if res[vim.api.nvim_win_get_buf(winnr)] ~= nil then --?:only allow verified buffers
				res[vim.api.nvim_win_get_buf(winnr)] = winnr
			end
		end
	end

	return res, bufnr_max_length
end

---@return table<integer, string>
function M:start()
	self.float.WINDOW.id_host = vim.api.nvim_get_current_win()
	self.float.BUFFER.id_to_host_map, self.float.BUFFER.id_max_length = self:mapBufferToWindow()

	local res = {}
	for bufnr, _ in pairs(self.float.BUFFER.id_to_host_map) do
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
	self.float.BUFFER.id_to_host_map = bufnr_to_winnr_map
	for idx, line in ipairs(vim.api.nvim_buf_get_lines(self.float.BUFFER.id_scratch, 0, -1, true)) do
		local row_idx = idx - deleted_lines - 1 --?: 0-based idx
		local bufnr = tonumber(line:match("(%d+)"))
		local host_flag = line:match("%*")

		if self.float.BUFFER.id_to_host_map[bufnr] == nil then
			vim.api.nvim_buf_set_lines(self.float.BUFFER.id_scratch, row_idx, row_idx + 1, true, {})

			deleted_lines = deleted_lines + 1
		else
			if self.float.BUFFER.id_to_host_map[bufnr] and not host_flag then --?:add "*"
				self:_changeFlag(row_idx, "*")
			elseif not self.float.BUFFER.id_to_host_map[bufnr] and host_flag then --?:remove "*"
				self:_changeFlag(row_idx, " ")
			end

			table.insert(remained_bufnrs, bufnr)
			remained_lines = remained_lines + 1
		end
	end

	--#add additional left paddings if one of the new buffers' legths exceeds previous one
	local extra_padding = bufnr_max_length - self.float.BUFFER.id_max_length
	if extra_padding > 0 then
		self:_addLeftPadding(remained_lines, extra_padding)
	end

	--#insert new buffers
	self.float.BUFFER.id_max_length = bufnr_max_length
	for bufnr, _ in pairs(bufnr_to_winnr_map) do
		if not vim.tbl_contains(remained_bufnrs, bufnr) then
			vim.api.nvim_buf_set_lines(self.float.BUFFER.id_scratch, -1, -1, true, {
				self:_formatLine(bufnr, bufnr_max_length),
			})
		end
	end
end

function M:switch()
	local lines = vim.api.nvim_buf_get_lines(self.float.BUFFER.id_scratch, 0, -1, true)

	local bufnr_to_detach = vim.api.nvim_win_get_buf(self.float.WINDOW.id_host)
	for index, line in ipairs(lines) do
		local row_idx = index - 1
		local bufnr = tonumber(line:match("(%d+)"))
		if bufnr == bufnr_to_detach and bufnr then
			self:_changeFlag(row_idx, " ")
			break
		end
	end

	local current_row_pos = vim.api.nvim_win_get_cursor(self.float.WINDOW.id_float)[1] --?:1-based index
	local bufnr_to_attach = tonumber(lines[current_row_pos]:match("(%d+)"))
	if bufnr_to_attach then
		self:_changeFlag(current_row_pos - 1, "*")
		self.float.BUFFER.id_to_host_map[bufnr_to_attach] = self.float.WINDOW.id_host
		vim.api.nvim_win_set_buf(self.float.WINDOW.id_host, bufnr_to_attach)
	end
end

---@param lines table<integer, string>
---@param start_idx integer
---@param end_idx integer
function M:_foo(lines, start_idx, end_idx)
	--?: use `vim.schedule`
end
function M:unloadBuf() --?:This method requires buffer's ID only
	local current_lines = vim.api.nvim_buf_get_lines(self.float.BUFFER.id_scratch, 0, -1, true) --?:recorded lines before deletion, then use `last_old`, `last_new` to detect deleted lines
	vim.api.nvim_buf_attach(self.float.BUFFER.id_scratch, true, {
		on_lines = function(_, _, _, first, last_old, last_new, _, _, _)
			local start_idx = first + 1 --?: `first` is 0-based index
			if last_old > last_new then
				--!: BUG => this will always use the `current_lines` of this firt initialized plugin.
				--?: INFO: the `first`, `last_old`, `last_new` are all updated
				--?: SOLUTION: update the `current_lines`, set1 - set2 = set3, if set3 is not empty, update one of 2
				print(start_idx, current_lines[1], #current_lines .. "\n")
			end
		end,
	})
end

--!: bug => every time the unloadBuf is triggered after repeatedly `reOpen` method is used, it created repeatedly scheduled jobs, which cause errors
function M:toggle()
	if not self.float.BUFFER.id_scratch then
		local lines = self:start()
		self.float:open(
			{ height = 0.4, width = 0.45 },
			{ height = vim.o.lines, width = vim.o.columns },
			{ title = "Buffer Switch", title_pos = "right" },
			lines
		)
		self:unloadBuf()
		vim.api.nvim_win_set_hl_ns(self.float.WINDOW.id_float, vim.api.nvim_create_namespace("switch.nvim"))
	elseif not self.float.WINDOW.id_float or not vim.api.nvim_win_is_valid(self.float.WINDOW.id_float) then --?:`BUFFER.id_scratch` avail, WINDOW.id_floating not avail or not valid
		self.float:reOpen(function()
			self:update()
		end)
	else
		self.float:hide() --?:both `BUFFER.id_scratch` and `WINDOW.id_floating` are avail
	end
end

return M
