local utils = require("switcher.utils")
local scratch_buffer = require("switcher.scratch_buffer")
local minimal_floating_window = require("switcher.minimal_floating_window")

--LSP will use the firt executable file named `python` in `bin` directory found in ENV's path
--Determine where to look for virtual environments (directories) -> list names -> make sure */bin of each venv is a DIRECTORY and EXISTING -> display the activated one

local M = {
	---@type string
	HOSTING_INDICATOR = "*",

	---Support `Anaconda` or `Miniconda`
	---@type string
	CONDA_HOME_PATH = vim.uv.os_homedir() .. "/miniconda3",

	---@type string
	WHICH_PYTHON = nil,

	---key: value = bin's path: true|false
	---@type table<string, boolean>
	IS_VENV_ACTIVATED_DICT = {
		[vim.uv.os_homedir() .. "/miniconda3/bin"] = false,
	},

	---key: value = abbreviated name: bin's path
	---@type table<string,string>
	ABBREVIATED_VENV_NAME_DICT = {
		["(base)"] = vim.uv.os_homedir() .. "/miniconda3/bin",
	},
}

---Check if a directory is EXISTING && NOT A FILE && NOT EMPTY
---@param path string
---@return string|nil
function M.verifyDirectory(path)
	local dir_info = vim.uv.fs_stat(path)
	if dir_info and (dir_info.type == "directory") and (dir_info.size > 0) then
		return path
	else
		return nil
	end
end

---@param path string|nil
function M:findCondaVirtualEnvs(path)
	local venvs_home_path = self.verifyDirectory(path or self.CONDA_HOME_PATH) --verify directory path
	if venvs_home_path then
		local dirs_names, _ = utils.scanDir(venvs_home_path .. "/envs")
		for _, dir_name in ipairs(dirs_names) do
			local bin_path = venvs_home_path .. "/envs/" .. dir_name .. "/bin"

			self.ABBREVIATED_VENV_NAME_DICT["(" .. dir_name .. ")"] = bin_path
			self.IS_VENV_ACTIVATED_DICT[bin_path] = false
		end
	end
end

function M:findHostedCondaVirtualEnvs()
	local current_python_exe_path = vim.fn.exepath("python")
	local python_bin_path = string.sub(current_python_exe_path, 1, current_python_exe_path:len() - ("/python"):len())

	self.IS_VENV_ACTIVATED_DICT[python_bin_path] = true
	self.WHICH_PYTHON = python_bin_path
end

--HOSTING_INDICATOR - ABBREVIATED_NAME - */bin PATH
function M:formatOutput()
	local res = {}
	for k, v in pairs(self.ABBREVIATED_VENV_NAME_DICT) do
		local hosting_indicator = self.IS_VENV_ACTIVATED_DICT[v] and self.HOSTING_INDICATOR or " " --single line if-else
		table.insert(res, hosting_indicator .. k .. " " .. v)
	end

	--return
	return res
end

---@param venv_to_activate string
function M:highlightActivatedVirtalEnv(venv_to_activate)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
	local is_activated_venv_highlighted, is_deactivated_venv_unhighlighted = false, false

	for row, line in ipairs(lines) do
		local tokens = utils.splitString(line, " ")
		if tokens[1]:sub(1, 1) == self.HOSTING_INDICATOR then
			for col, char in ipairs(utils.iterString(line)) do --?:breakable loop
				if char == self.HOSTING_INDICATOR then
					vim.api.nvim_buf_set_text(0, row - 1, col - 1, row - 1, col, { " " })
					is_deactivated_venv_unhighlighted = true
					break --?: prevent looping without purpose
				end
			end
		elseif tokens[1]:sub(1, -1) == venv_to_activate then
			for col, char in ipairs(utils.iterString(line)) do --?:breakable loop
				if char ~= " " then
					vim.api.nvim_buf_set_text(0, row - 1, col - 2, row - 1, col - 1, { self.HOSTING_INDICATOR })
					is_activated_venv_highlighted = true
					break --?: prevent looping without purpose
				end
			end
		end

		if is_activated_venv_highlighted == is_deactivated_venv_unhighlighted then --?: break the outermost loop
			break
		end
	end
end

function M:switchVirtualEnv()
	local tokens = utils.splitString(vim.api.nvim_get_current_line(), " ") --?:tokens[1] -> `ABBREVIATED_NAME` of bin's path, tokens[2] -> bin path
	if tokens[1]:sub(1, 1) ~= self.HOSTING_INDICATOR then --?: check if selected venv is activated or not
		self:highlightActivatedVirtalEnv(tokens[1])

		vim.env.PATH = os.getenv("PATH"):gsub(self.WHICH_PYTHON, tokens[2], 1)
		vim.api.nvim_cmd({ cmd = "LspRestart" }, { output = true })

		self.IS_VENV_ACTIVATED_DICT[self.WHICH_PYTHON] = false --?:change last activated virtual environment status to `false` (INACTIVE)
		self.WHICH_PYTHON = tokens[2]
	else
		print("This virtual environment has been activated!")
	end
end

function M:init()
	self:findCondaVirtualEnvs()
	self:findHostedCondaVirtualEnvs()

	local formatted_output = self:formatOutput()
	local scratch_bufnr = scratch_buffer.createMutableScratchBuf()
	vim.api.nvim_buf_set_lines(scratch_bufnr, 0, -1, true, formatted_output)
	utils:align2Words(scratch_bufnr, " ")
	minimal_floating_window.openFloatingWindow(scratch_bufnr, "Switch Virtual Environment (Python)")

	--[[remap: 
    --  <CR> to evoke the `switchVirtualEnv` function
    --  <CMD>q<CR> to `q` to shorten exit command
    --]]
	vim.keymap.set("n", "q", "<CMD>q<CR>", { buffer = scratch_bufnr })
	vim.keymap.set("n", "<CR>", function()
		self:switchVirtualEnv()
	end, { buffer = scratch_bufnr })
end

return M
