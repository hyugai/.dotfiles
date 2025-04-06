local M = {}
local api = vim.api
local buf_M, win_M
local active_bufs = {}

-- #
function M.create_win_for_buf()
	buf_M = api.nvim_create_buf(false, true)
	api.nvim_set_option_value("bufhidden", "wipe", { buf = buf_M })

	local current_width = api.nvim_win_get_width(0)
	local current_height = api.nvim_win_get_height(0)

	local sub_win_width = math.ceil(current_width*0.5 - 5)
	local sub_win_height = math.ceil(current_height*0.5)

    -- starting positions of the sub window
	local loc_x = math.ceil((current_width - sub_win_width)/2 - 1)
	local loc_y = math.ceil((current_height - sub_win_height)/2)

	local sub_win_opts = {
		style = "minimal",
		relative = "editor",
		width = sub_win_width,
		height = sub_win_height,
		row = 0, -- loc_x
		col = 0, -- loc_y
	}
	win_M = api.nvim_open_win(buf_M, true, sub_win_opts)
end

-- #
-- TODO: remove neotree's buffer
function M.push_texts()
    -- buffers' IDs
    local bufs_ids = api.nvim_list_bufs() -- return buffers' IDs

    -- active buffers
    for _, buf_id in ipairs(bufs_ids) do
        local buf_name = api.nvim_buf_get_name(buf_id)
        if (api.nvim_buf_is_loaded(buf_id)) and (string.len(buf_name) ~= 0) then
            active_bufs[buf_name] = buf_id
        end
    end

    local bufs_names = {}
    for buf_name, _ in pairs(active_bufs) do
        table.insert(bufs_names, buf_name)
    end
    api.nvim_buf_set_lines(buf_M, 0, -1, false, bufs_names)
end

-- #
function M.select_buf()
    local loc_cursor = api.nvim_win_get_cursor(win_M) -- { row, column }
    local current_line = api.nvim_buf_get_lines(buf_M, loc_cursor[1]-1, loc_cursor[1], false)[1] -- since this function will return a single-value table, so we'll get it in advance
    local buf_id = active_bufs[current_line]
    api.nvim_win_close(0, true) -- close the win_M
    api.nvim_win_set_buf(0, buf_id) --use the window that evoke this module to open the selected buf
end

-- #
function M.main()
    M.create_win_for_buf()
    M.push_texts()

    api.nvim_buf_create_user_command(buf_M, "OpenBuf", M.select_buf, {})
    api.nvim_buf_set_keymap(buf_M, "n", "<cr>", ":SelectBuf<cr>", { noremap = true})
end

-- #
function M.setup(opts)
    opts = opts or {}

    vim.keymap.set("n", "<leader>h", M.main, { noremap = true })
end

-- #
return M
