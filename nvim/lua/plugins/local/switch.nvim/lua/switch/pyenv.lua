local utils = require("switch.utils")
local M = {
	ENV = {
		---@type integer
		name_max_length = 0,
		---@type table<string, string>
		name_to_path_map = {},
		---@type string
		name_activated_env = "",
	},
}
M.float = require("switch.toggle_float"):new()

--#async
---asynchronous function started at initilization
---when opening NeoVim -> mapNameToPath_async, open floating for the first time -> use pre-loaded data, run mapNameToPath_async then update
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

function M:mapNameToPath_async()
	vim.system({ "conda", "env", "list" }, { text = true }, function(out)
		if out.code == 0 then
			local lines = utils.splitString(out.stdout, "\n") --?: output of above shell command is multilines ended with `\n`
			for i = 3, #lines, 1 do
				local env_name = lines[i]:match("%w+") --?: first match
				local is_flagged = lines[i]:match("%*") == "*"
				if is_flagged then
					self.ENV.name_activated_env = env_name
				end
				self.ENV.name_max_length = env_name:len() >= self.ENV.name_max_length and env_name:len()
					or self.ENV.name_max_length

				self.ENV.name_to_path_map[env_name] = lines[i]:match("/.*$") --?: matches begin at `/` and continue til the end of string (`$`)
			end
		end
	end)
end

function M:init_async()
	self:mapNameToPath_async()
end

function M:start_async()
	local lines = {}

	for name, _ in pairs(self.ENV.name_to_path_map) do
		table.insert(lines, self:_formatLine(name))
	end

	return lines
end

function M:update_async() end
--#endasync

function M:toggle()
	if not self.float.BUFFER.id_scratch then
		local lines = self:start_async()
		self.float:open(
			{ height = 0.4, width = 0.45 },
			{ height = vim.o.lines, width = vim.o.columns },
			{ title = "Python Virtual Env Switch", title_pos = "center" },
			lines
		)
		vim.api.nvim_win_set_hl_ns(self.float.WINDOW.id_float, vim.api.nvim_create_namespace("switch.nvim"))
	elseif not self.float.WINDOW.id_float or not vim.api.nvim_win_is_valid(self.float.WINDOW.id_float) then --?:`BUFFER.id_scratch` avail, WINDOW.id_floating not avail or not valid
		self.float:reOpen(function()
			self:update_async()
		end)
	else
		self.float:hide() --?:both `BUFFER.id_scratch` and `WINDOW.id_floating` are avail
		--!: may use `update_async` or `init_async` function
	end
end

function M:switch()
	local lines = vim.api.nvim_buf_get_lines(self.float.BUFFER.id_scratch, 0, -1, true)

	local cursor_row_pos = vim.api.nvim_win_get_cursor(self.float.WINDOW.id_float)[1]
	if lines[cursor_row_pos]:match("%*") ~= "*" then
		local env_to_activate = lines[cursor_row_pos]:match("%w+")
		local current_python_bin_path, _ = vim.fn.exepath("python"):gsub("/python", "")
		--!: do sth with this
		vim.env.PATH = os.getenv("PATH")
			:gsub(current_python_bin_path, self.ENV.name_to_path_map[env_to_activate] .. "/bin")

		for index, line in ipairs(lines) do
			local row_idx = index - 1
			if line:match("*") == "*" then
				self:_changeFlag(row_idx, " ")
				break
			elseif line:match("%w+") == env_to_activate then
				self.ENV.name_activated_env = env_to_activate
				self:_changeFlag(row_idx, "*")
				vim.api.nvim_cmd({ cmd = "LspRestart" }, { output = true })
			end
		end
	else
		print("This environment's activated already!")
	end
end

return M
