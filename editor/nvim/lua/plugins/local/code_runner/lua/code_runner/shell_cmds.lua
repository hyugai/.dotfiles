local utils = require("code_runner.utils")
local sided_terminal = require("code_runner.sided_terminal")

local M = {}

function M.run(args)
	--return execution commands equivalent to file format
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
		elseif file["format"] == "lua" then
			return "lua" .. (args:len() ~= 0 and args .. " " or " ") .. file["path"]
		else
			return false
		end
	end

	--main
	local cmds = getCmds()
	if cmds then
		sided_terminal:runCode(cmds)
	else
		print("File format not supported!")
	end
end

return M
