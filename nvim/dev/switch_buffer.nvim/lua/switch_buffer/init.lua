local M = {}
local supports = require("switch_buffer.supports")

function M.setup(opts)
    vim.keymap.set("n", "<leader>h", function()
        supports.switch_buf()
    end, { noremap = true })
end

return M
