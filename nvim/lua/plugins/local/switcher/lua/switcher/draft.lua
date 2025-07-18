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

-- KEYMAP, USER'S COMMAND, AUTOCOMMAND
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
