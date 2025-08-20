local M = {}
--!: apply OOP to `toggle_float`
local toggle_float = require("switch.toggle_float")
local buffer = require("switch.buffer")
local pyenv = require("switch.pyenv")

function M.setup(_)
	local ns_id = vim.api.nvim_create_namespace("switch.nvim")
	vim.api.nvim_set_hl(ns_id, "FloatBorder", { fg = "#ff8800" })

	vim.api.nvim_create_autocmd("User", {
		pattern = "switch.nvim",
		callback = function(args)
			local src = require("switch." .. args.data)
			vim.keymap.set("n", "q", function()
				src.float:terminate()
			end, { buffer = src.float.BUFFER.id_scratch })

			vim.keymap.set("n", "<CR>", function()
				src:switch()
			end, { buffer = src.float.BUFFER.id_scratch })
		end,
	})

	vim.api.nvim_create_user_command("SwitchBuf", function(_)
		buffer:toggle()
		vim.api.nvim_exec_autocmds("User", {
			pattern = "switch.nvim",
			data = "buffer",
		})
	end, {})
	vim.keymap.set("n", "<leader>sb", "<CMD>SwitchBuf<CR>")

	vim.api.nvim_create_user_command("SwitchPyEnv", function(_)
		pyenv:toggle()
		vim.api.nvim_exec_autocmds("User", {
			pattern = "switch.nvim",
			data = "pyenv",
		})
	end, {})
	vim.keymap.set("n", "<leader>sp", "<CMD>SwitchPyEnv<CR>")
end

return M
