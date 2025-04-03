local M = {}
local supports = require("bufferui.supports")

function M.setup()
    vim.keymap.set("n", "<leader>h", function()
        supports.main()
    end, { noremap = true })
end

return M
