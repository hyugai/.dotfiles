-- use `:` for nested function used `self`

-- ICONS
local icons = {
	ATTACHED = " ✓",
	DETACHED = " ✗",
}

-- BUF
local buffer = {
	ID = nil,
	CONTENT = {},
	LOADED_BUFS = {},
	get_loaded_bufs = function(self)
		local buf_ids = vim.api.nvim_list_bufs()
		for _, v in ipairs(buf_ids) do
			local buf_name = vim.api.nvim_buf_get_name(v)
			if vim.api.nvim_buf_is_loaded(v) and vim.uv.fs_stat(buf_name) then
				self.LOADED_BUFS[buf_name] = {
					id = v,
					is_attached = false,
				}
			end
		end
	end,
	get_currently_attached_bufs = function(self)
		local win_ids = vim.api.nvim_list_wins()
		for _, v in ipairs(win_ids) do
			if vim.api.nvim_win_is_valid(v) then
				local buf_id = vim.api.nvim_win_get_buf(v)
				local buf_name = vim.api.nvim_buf_get_name(buf_id)
				if vim.api.nvim_buf_is_loaded(buf_id) and vim.uv.fs_stat(buf_name) then
					self.LOADED_BUFS[buf_name].is_attached = true
				end
			end
		end
	end,
	label_bufs = function(self)
		self.CONTENT = {}
		self:get_currently_attached_bufs()
		for k, v in pairs(self.LOADED_BUFS) do
			if v.is_attached then
				table.insert(self.CONTENT, k .. icons.ATTACHED)
			else
				table.insert(self.CONTENT, k .. icons.DETACHED)
			end
		end
	end,
	new = function(self) -- this function is used once everytime evoke this plugin
		self:get_loaded_bufs()
		self:label_bufs()
		self.ID = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(self.ID, 0, -1, true, self.CONTENT)
		vim.api.nvim_set_option_value("buftype", "nofile", { buf = self.ID })
		vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = self.ID })
		vim.api.nvim_set_option_value("swapfile", false, { buf = self.ID })
	end,
	switch_buf = function(self, buf_to_attach, host_win) -- modify `LOADED_BUFS`
		self.LOADED_BUFS[buf_to_attach].is_attached = true

		local prev_attached_buf_id = vim.api.nvim_win_get_buf(host_win) -- the window used to attach to new buf will be currently hold the altered buf, so we can retrive that buf and set its to `false` like below
		local prev_attached_buf_name = vim.api.nvim_buf_get_name(prev_attached_buf_id)
		self.LOADED_BUFS[prev_attached_buf_name].is_attached = false
		vim.api.nvim_win_set_buf(host_win, self.LOADED_BUFS[buf_to_attach].id) -- this mustbe placed before `buffer:label_bufs` (the below line)

		self:label_bufs()
	end,
}

-- WIN
local window = {
	ID = nil,
	HOST = nil,
	record_current_win = function(self)
		self.HOST = vim.api.nvim_get_current_win()
	end,
	calculate_sizes = function()
		local width = { start = ((1 - 0.5) / 2) * vim.o.columns, magnitude = math.ceil(vim.o.columns * 0.5) }
		local height = { start = ((1 - 0.5) / 2) * vim.o.lines, magnitude = math.ceil(vim.o.lines * 0.5) }

		return width, height
	end,
	open = function(self)
		buffer:new()

		self:record_current_win()
		local width, height = self.calculate_sizes()
		self.ID = vim.api.nvim_open_win(buffer.ID, true, {
			relative = "editor",
			width = width.magnitude,
			height = height.magnitude,
			col = width.start,
			row = height.start,
			style = "minimal",
			border = "rounded",
		})
	end,
}

-- EDITOR
local editor = {
	WIDTH = nil,
	HEIGHT = nil,
	record_current_sizes = function(self)
		self.WIDTH = vim.o.columns
		self.HEIGHT = vim.o.lines
	end,
	is_resized = function(self)
		if self.WIDTH ~= vim.o.columns or self.HEIGHT ~= vim.o.lines then
			self:record_current_sizes()
			return true
		else
			return false
		end
	end,
}

vim.api.nvim_create_user_command("SwitchBuf", function()
	window:open()
end, {})
vim.keymap.set("n", "<CR>", function()
	local selected_line = vim.api.nvim_get_current_line()

	for _, v in pairs(icons) do
		selected_line = string.gsub(selected_line, v, "")
	end
	buffer:switch_buf(selected_line, window.HOST)

	vim.api.nvim_buf_set_lines(buffer.ID, 0, -1, true, buffer.CONTENT)
end)
vim.api.nvim_create_autocmd("WinResized", {
	callback = function()
		if editor:is_resized() then
			local width, height = window.calculate_sizes()
			if window.ID and vim.api.nvim_win_is_valid(window.ID) then -- double check if this window for this plugin existed
				vim.api.nvim_win_set_config(window.ID, {
					relative = "editor",
					width = width.magnitude,
					height = height.magnitude,
					col = width.start,
					row = height.start,
				})
			end
		end
	end,
})
