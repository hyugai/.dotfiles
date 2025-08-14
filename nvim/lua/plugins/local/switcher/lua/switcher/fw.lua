local M = {}

---@param scale_sizes table<string, integer>
---@param editor table<string, integer>
---@param opts table<string, integer|string|boolean>
function M.setOpts(scale_sizes, editor, opts)
	opts.height = math.ceil(editor.height * scale_sizes.height)
	opts.width = math.ceil(editor.width * scale_sizes.width)

	opts.row = math.ceil(((1 - scale_sizes.height) / 2) * editor.height)
	opts.col = math.ceil(((1 - scale_sizes.width) / 2) * editor.width)

	return opts
end

return M
