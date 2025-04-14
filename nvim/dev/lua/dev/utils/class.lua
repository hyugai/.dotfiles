--# set
local Set = {
	to_set = function(list)
		local res = {}
		for _, value in ipairs(list) do
			res[value] = true
		end

		return res
	end,
}

function Set:new(list)
	local obj = self.to_set(list)
	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Set:lookup_values(values)
	local valid = {
		idxes = {},
		values = {},
	}
	for idx, value in ipairs(values) do
		if self[value] then
			table.insert(valid.idxes, idx)
			table.insert(valid.values, value)
		end
	end

	return valid
end

--# menu
local Menu = {
	configure_buf = function(content)
		local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, true, content)
		vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
		vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

		return buf
	end,
	configure_win = function(opts)
		local width = {
			max = vim.o.columns,
			scaling_factor = opts.width_ratio or 0.5,
		}
		local height = {
			max = vim.o.lines,
			scaling_factor = opts.height_ratio or 0.5,
		}

		return {
			relative = opts.relative or "editor",
			row = ((1 - height.scaling_factor) / 2) * height.max,
			col = ((1 - width.scaling_factor) / 2) * width.max,
			height = math.floor(height.max * height.scaling_factor),
			width = math.floor(width.max * width.scaling_factor),
			title = opts.title or "Title",
			title_pos = opts.title_pos or "center",
			style = opts.style or "minimal",
			border = opts.border or "rounded",
		}
	end,
}

function Menu:new(opts, texts)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.buf = self.configure_buf(texts)
	obj.opts = self.configure_win(opts)
    obj.hosting_win = vim.api.nvim_get_current_win()

	return obj
end

function Menu:resize_autonomously()
	vim.api.nvim_create_autocmd("VimResized", {
		callback = function()
			local old_opts = vim.api.nvim_win_get_config(0)
			local new_opts = self.configure_win(old_opts)
			if vim.api.nvim_win_is_valid(0) then
				vim.api.nvim_win_set_config(0, new_opts)
			end
		end,
	})
end

--# returned package
local M = {
	Set = Set,
	Menu = Menu,
}

return M
