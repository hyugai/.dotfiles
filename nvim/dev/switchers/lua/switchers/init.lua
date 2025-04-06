local contexts = {
	buffer = require("switchers.buffer"),
}

local function setup(opts)
    -- user's cmd
	vim.api.nvim_create_user_command("SwitchBuffer", function()
		local metadata = contexts.buffer.open_menu(opts.buffer)
		vim.keymap.set("n", "<CR>", function()
			contexts.buffer.attach_buffer_to_window(metadata.popup_win.previous_win_id, metadata.file_paths_dict)
		end, { noremap = true, buffer = metadata.buf_id })
		vim.keymap.set("n", "q", ":q<CR>", { noremap = true, buffer = metadata.buf_id })
	end, { desc = "Attach another activate buffer to the current window" })

    -- keymap for above user's cmd
	vim.keymap.set("n", "<leader>sb", ":SwitchBuffer<CR>", { noremap = true })
end

local M = {
	setup = setup,
}
return M
