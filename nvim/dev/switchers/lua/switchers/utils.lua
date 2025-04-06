local M = {}

function M.get_id_of_configured_buf(text)
    local buf_id = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, true, text)
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf_id })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf_id })

    return buf_id
end

function M.get_win_opts(user_opts)
    local dim = {
        max_width = vim.o.columns,
        max_height = vim.o.lines,
        width_scale = user_opts.width_scale or 0.5,
        height_scale = user_opts.height_scale or 0.5,
    }

    local opts = {
        relative = user_opts.relative or "editor",
        row = ((1 - dim.height_scale) / 2) * dim.max_height,
        col = ((1 - dim.width_scale) / 2) * dim.max_width,
        width = math.floor(dim.width_scale * dim.max_width),
        height = math.floor(dim.height_scale * dim.max_height),
        title = user_opts.title or "No title",
        title_pos = user_opts.title_pos or "center",
        style = user_opts.style or "minimal",
        border = user_opts.border or "rounded",
    }

    return opts
end

function M.autoresize_popup_win(user_opts, win_id)
    vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
            -- BUG here
            local modified_opts = get_win_opts(user_opts)
            vim.api.nvim_win_set_config(win_id, modified_opts)
        end
    })
end

function M.unpack_dict(t)
    local keys, values = {}, {}
    for key, value in pairs(t) do
        table.insert(keys, key)
        table.insert(values, value)
    end

    return keys, values
end

function M.simplify_paths(file_paths, pattern, repl)
    local result = {}
    for _, file_path in ipairs(file_paths) do
        local start_idx, _ = string.find(file_path, pattern)
        if start_idx ~= 1 then
            local simplified_path = string.gsub(file_path, pattern, repl)
            table.insert(result, simplified_path)
        end
    end

    return result
end

return M
