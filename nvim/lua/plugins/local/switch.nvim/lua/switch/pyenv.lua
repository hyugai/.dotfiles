local utils = require("switch.utils")
local M = {
	ENV = {
		---@type integer
		name_max_length = 0,
		---@type table<string, string>
		name_to_path_map = {},
		---@type string
		name_activated_env = nil,
	},
}
M.float = require("switch.toggle_float"):new()

function M:_changeFlag(row_idx, flag)
	vim.api.nvim_buf_set_text(
		self.float.BUFFER.id_scratch,
		row_idx,
		self.ENV.name_max_length + 1,
		row_idx,
		self.ENV.name_max_length + 2,
		{ flag }
	)
end

---@param name string
---@param name_max_length integer?
---@return string
function M:_formatLine(name, name_max_length)
	local length_diff = name_max_length and name_max_length - name:len() or self.ENV.name_max_length - name:len()

	return (" "):rep(length_diff + 1)
		.. name
		.. (self.ENV.name_activated_env == name and "*" or " ")
		.. (" "):rep(2)
		.. self.ENV.name_to_path_map[name]
end

function M:mapNameToPath()
	local obj = vim.system({ "conda", "env", "list" }, { text = true }):wait() --?: waiting for the shell command to be completed
	if obj.code == 0 then
		local lines = utils.splitString(obj.stdout, "\n")
		for i = 3, #lines, 1 do
			local tokens = utils.splitString(lines[i], " ")
			local env_name = tokens[1]:match("%w+")
			local is_flaged = vim.tbl_contains(tokens, "*")

			if is_flaged then
				self.ENV.name_activated_env = env_name
			end
			self.ENV.name_to_path_map[env_name] = tokens[#tokens]
			self.ENV.name_max_length = self.ENV.name_max_length >= env_name:len() and self.ENV.name_max_length
				or env_name:len()
		end
	end
end

function M:start()
	self:mapNameToPath()
	--print(self.ENV.name_activated_env)

	local res = {}
	for name, _ in pairs(self.ENV.name_to_path_map) do
		table.insert(res, self:_formatLine(name))
	end

	return res
end

function M:switch()
	local lines = vim.api.nvim_buf_get_lines(self.float.BUFFER.id_scratch, 0, -1, true)

	local cursor_row_pos = vim.api.nvim_win_get_cursor(self.float.WINDOW.id_float)[1]
	if lines[cursor_row_pos]:match("%*") ~= "*" then
		local env_to_activate = lines[cursor_row_pos]:match("%w+")
		local current_python_bin_path, _ = vim.fn.exepath("python"):gsub("/python", "")
		vim.env.PATH = os.getenv("PATH")
			:gsub(current_python_bin_path, self.ENV.name_to_path_map[env_to_activate] .. "/bin")

		for index, line in ipairs(lines) do
			local row_idx = index - 1
			if line:match("*") == "*" then
				self:_changeFlag(row_idx, " ")
				break
			end
		end

		self.ENV.name_activated_env = env_to_activate
		self:_changeFlag(cursor_row_pos - 1, "*")
		vim.api.nvim_cmd({ cmd = "LspRestart" }, { output = true })
	else
		print("This environment's activated already!")
	end
end

--print(os.getenv("PATH"))
function M:toggle()
	if not self.float.BUFFER.id_scratch then
		local lines = self:start()
		self.float:open(
			{ height = 0.4, width = 0.45 },
			{ height = vim.o.lines, width = vim.o.columns },
			{ title = "PyEnv Switch", title_pos = "center" },
			lines
		)
		vim.api.nvim_win_set_hl_ns(self.float.WINDOW.id_float, vim.api.nvim_create_namespace("switch.nvim"))
	elseif not self.float.WINDOW.id_float or not vim.api.nvim_win_is_valid(self.float.WINDOW.id_float) then --?:`BUFFER.id_scratch` avail, WINDOW.id_floating not avail or not valid
		self.float:reOpen(function()
			--self:update()
		end)
	else
		self.float:hide() --?:both `BUFFER.id_scratch` and `WINDOW.id_floating` are avail
	end
end

return M
