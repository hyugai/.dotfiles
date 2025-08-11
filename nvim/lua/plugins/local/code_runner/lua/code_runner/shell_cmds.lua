local utils = require("code_runner.utils")
local sided_terminal = require("code_runner.sided_terminal")

local M = {}

---@param args string
---@return string|boolean
function M.get(args)
	local file = {}
	file["path"] = vim.api.nvim_buf_get_name(0)
	file["format"] = utils:extractFileFormat(file["path"])

	if file["format"] == "c" then
		return "gcc" .. (args:len() ~= 0 and args .. " " or " ") .. file["path"] .. " && ./a.out"
	elseif file["format"] == "cpp" then
		return "g++" .. (args:len() ~= 0 and args .. " " or " ") .. file["path"] .. " && ./a.out"
	elseif file["format"] == "py" then
		return "python" .. (args:len() ~= 0 and args .. " " or " ") .. file["path"]
	else
		return false
	end
end

function M.run(args)
	local function getCmds()
		local file = {}
		file["path"] = vim.api.nvim_buf_get_name(0)
		file["format"] = utils:extractFileFormat(file["path"])

		if file["format"] == "c" then
			return "gcc" .. (args:len() ~= 0 and args .. " " or " ") .. file["path"] .. " && ./a.out"
		elseif file["format"] == "cpp" then
			return "g++" .. (args:len() ~= 0 and args .. " " or " ") .. file["path"] .. " && ./a.out"
		elseif file["format"] == "py" then
			return "python" .. (args:len() ~= 0 and args .. " " or " ") .. file["path"]
		else
			return false
		end
	end

    --main 
	local cmds = getCmds()
	if cmds then
		sided_terminal:init(cmds)
	else
		print("File format not supported!")
	end
end

return M
