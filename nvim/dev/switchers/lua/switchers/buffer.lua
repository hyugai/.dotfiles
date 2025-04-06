local utils = require("switchers.utils")

local function lookup_file_paths()
    local file_paths_dict = {}
    local active_buf_ids = vim.api.nvim_list_bufs()
    for _, buf_id in ipairs(active_buf_ids) do
        local file_path = vim.api.nvim_buf_get_name(buf_id)
        if vim.uv.fs_stat(file_path) then
            file_paths_dict[file_path] = buf_id
        end
    end

    return file_paths_dict
end

local function open_menu(opts)
    local file_paths_dict = lookup_file_paths()
    local file_paths, _ = utils.unpack_dict(file_paths_dict)
    local buf_id = utils.get_id_of_configured_buf(file_paths)

    local popup_win = {}
    popup_win.previous_win_id = vim.api.nvim_get_current_win()
    popup_win.opts = utils.get_win_opts(opts)
    popup_win.id = vim.api.nvim_open_win(buf_id, true, popup_win.opts)
    utils.autoresize_popup_win(opts, popup_win.id)

    -- metadata
    return {
        buf_id = buf_id,
        popup_win = popup_win,
        file_paths_dict = file_paths_dict,
    }
end

local function attach_buffer_to_window(previous_win_id, file_paths_dict)
    local selected_file_path = vim.api.nvim_get_current_line()
    vim.api.nvim_win_set_buf(previous_win_id, file_paths_dict[selected_file_path])
end

local M = {
    open_menu = open_menu,
    attach_buffer_to_window = attach_buffer_to_window,
}

return M
