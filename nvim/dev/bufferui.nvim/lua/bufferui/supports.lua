local M = {}

--# __lookup_files_paths -> check if a file path exists or not
function M.__lookup_files_paths(bufs)
    local existing_files_paths = {}
    for _, buf_id in ipairs(bufs) do
        local file_path = vim.api.nvim_buf_get_name(buf_id)
        if vim.uv.fs_stat(file_path) then
            existing_files_paths[file_path] = buf_id
        end
    end

    return existing_files_paths
end

function M.__config_popup_win(width_scale, height_scale)
    local vim_height = vim.o.lines
    local vim_width = vim.o.columns

    local loc_x = vim_width * ((1 - width_scale) / 2)
    local loc_y = vim_height * ((1 - height_scale) / 2)

    local sub_win_opts = {
        relative = "editor",
        row = loc_y,
        col = loc_x,
        width = math.floor(vim_width * width_scale),
        height = math.floor(vim_height * height_scale),
        style = "minimal",
        border = "rounded",
    }

    return sub_win_opts
end

function M.main()
    local active_bufs = vim.api.nvim_list_bufs()
    local files_paths_dict = M.__lookup_files_paths(active_bufs)
    local files_paths = {}
    for key, _ in pairs(files_paths_dict) do
        table.insert(files_paths, key)
    end

    local buf_id = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, true, files_paths)
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf_id })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf_id })

    local curr_win_id = vim.api.nvim_get_current_win()
    local width_scale = 0.5
    local height_scale = 0.5
    local popup_win_opts = M.__config_popup_win(width_scale, height_scale)
    local popup_win_id = vim.api.nvim_open_win(buf_id, true, popup_win_opts)

    --# attach existing buffer to an existing window
    vim.keymap.set("n", "<CR>", function()
        local selected_file_path = vim.api.nvim_get_current_line()
        local buf_attributed_to_path = files_paths_dict[selected_file_path]
        vim.api.nvim_win_set_buf(curr_win_id, buf_attributed_to_path)
    end, { buffer = buf_id })
    vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
            local modified_opts = M.__config_popup_win(width_scale, height_scale)
            vim.api.nvim_win_set_config(popup_win_id, {
                row = modified_opts.row,
                col = modified_opts.col,
                width = modified_opts.width,
                height = modified_opts.height,
            })
        end,
    })
end

return M
