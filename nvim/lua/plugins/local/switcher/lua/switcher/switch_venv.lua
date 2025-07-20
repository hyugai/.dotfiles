local utils = require("switcher.utils")

--[[
--LSP will use the firt executable file named `python` in `bin` directory found in ENV's path
--Determine where to look for virtual environments (directories) -> list names -> make sure */bin of each venv is a DIRECTORY and EXISTING -> display the activated one
--]]
local M = {
	---@type string
	HOSTING_INDICATOR = "*",
	---Support `Anaconda` or `Miniconda`
	---@type string
	DEFAULT_CONDA_PATH = vim.uv.os_homedir() .. "/miniconda3",
	---@type string
	WHICH_PYTHON = nil, --
	---@type table<string, boolean>
	IS_VENV_ACTIVATED_DICT = {
		[vim.uv.os_homedir() .. "/miniconda3/bin"] = false,
	},
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
	local venvs_dir_path = self.verifyDirectory(path or self.DEFAULT_CONDA_PATH) --verify directory path
	if venvs_dir_path then
		local dirs_names, _ = utils.scanDir(venvs_dir_path .. "/envs")
		for _, dir_name in ipairs(dirs_names) do
			local bin_dir = venvs_dir_path .. "/envs/" .. dir_name .. "/bin"
			self.ABBREVIATED_VENV_NAME_DICT["(" .. dir_name .. ")"] = bin_dir
			self.IS_VENV_ACTIVATED_DICT[bin_dir] = false
		end
	end
end

function M:findHostedCondaVirtualEnvs()
	local bin_dir_of_activated_venv =
		string.sub(vim.fn.exepath("python"), 1, vim.fn.exepath("python"):len() - ("/python"):len())
	self.IS_VENV_ACTIVATED_DICT[bin_dir_of_activated_venv] = true
	self.WHICH_PYTHON = bin_dir_of_activated_venv
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

function M:switchVirtualEnv()
	local tokens = utils.splitString(vim.api.nvim_get_current_line(), " ")
	if tokens[1]:sub(1, 1) ~= self.HOSTING_INDICATOR then
		utils:highlightActivatedVirtualEnvironment(tokens[1])

		vim.env.PATH = os.getenv("PATH"):gsub(self.WHICH_PYTHON, tokens[2], 1)
		vim.api.nvim_cmd({ cmd = "LspRestart" }, {})

		self.WHICH_PYTHON = tokens[2]
	else
		print("This virtual environment has been activated!")
	end
end

function M:init()
	self:findCondaVirtualEnvs()
	self:findHostedCondaVirtualEnvs()

	local formatted_output = self:formatOutput()
	local scratch_bufnr = utils.createScratchBuf()
	vim.api.nvim_buf_set_lines(scratch_bufnr, 0, -1, true, formatted_output)
	utils:align2Words(scratch_bufnr, " ")
	utils.openFloatingWindow(scratch_bufnr, "Switch Virtual Environment (Python)")

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
