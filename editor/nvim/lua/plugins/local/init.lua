local M = {
	PATH = {
		---@type string
		src = debug.getinfo(1, "S").source:sub(2):gsub("init.lua", ""),

		---@type table<integer, table<string, string>>
		local_plugins = {},
	},
}

function M:scanPlugins()
	local excluded_dirs = { "utils" }
	local dir, _, _ = vim.uv.fs_scandir(self.PATH.src)
	while true and dir do
		local name, type, _ = vim.uv.fs_scandir_next(dir)
		if name then
			if type == "directory" and not vim.tbl_contains(excluded_dirs, name) then
				table.insert(self.PATH.local_plugins, { dir = self.PATH.src .. name })
			end
		else
			break
		end
	end
end
M:scanPlugins()

return M.PATH.local_plugins
