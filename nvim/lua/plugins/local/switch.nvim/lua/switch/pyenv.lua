local utils = require("switch.utils")
local M = {
	FLAGGED_NAME = {
		---@type integer
		max_length = nil,
		---@type table<string, string>
		name_to_path_map = nil,
	},
}
M.float = require("switch.toggle_float"):new()

---@param flagged_name string
---@param flagged_name_max_length integer?
function M:_formatLine(flagged_name, flagged_name_max_length)
	local length_diff = flagged_name_max_length and flagged_name_max_length - flagged_name:len()
		or self.FLAGGED_NAME.max_length - flagged_name:len()

	return (" "):rep(length_diff + 1)
		.. flagged_name
		.. (" "):rep(2)
		.. self.FLAGGED_NAME.name_to_path_map[flagged_name]
end

---@return table<string, string>
---@return integer
function M.mapNameToPath()
	local res = {}
	local flagged_name_max_length = 0
	vim.system({ "conda", "env", "list" }, { text = true }, function(out)
		if out.code == 0 then
			local lines = utils.splitString(out.stdout, "\n")
			for i = 3, #lines, 1 do
				local tokens = utils.splitString(lines[i], " ")
				local flagged_name = tokens[1] .. (vim.tbl_contains(tokens, "*") and "*" or " ")
				flagged_name_max_length = flagged_name_max_length >= flagged_name:len() and flagged_name_max_length
					or flagged_name:len()

				res[flagged_name] = tokens[#tokens]
			end
		end
	end)

	return res, flagged_name_max_length
end

function M:start()
	self.FLAGGED_NAME.name_to_path_map, self.FLAGGED_NAME.max_length = self.mapNameToPath()

	local res = {}
	for flagged_name, _ in pairs(self.FLAGGED_NAME.name_to_path_map) do
		table.insert(res, self:_formatLine(flagged_name))
	end

	return res
end

function M:switch() end
function M:toggle()
	if not self.float.BUFFER.id_scratch then
		local lines = self:start()
		self.float:open(
			{ height = 0.4, width = 0.45 },
			{ height = vim.o.lines, width = vim.o.columns },
			{ title = "PyEnv Switch", title_pos = "center" },
			lines
		)
		--	vim.api.nvim_win_set_hl_ns(toggle_float.WINDOW.id_float, vim.api.nvim_create_namespace("switch.nvim"))
		--elseif not toggle_float.WINDOW.id_float or not vim.api.nvim_win_is_valid(toggle_float.WINDOW.id_float) then --?:`BUFFER.id_scratch` avail, WINDOW.id_floating not avail or not valid
		--	toggle_float:reOpen(function()
		--		self:update()
		--	end)
		--else
		--	toggle_float:hide() --?:both `BUFFER.id_scratch` and `WINDOW.id_floating` are avail
	end
end

return M
