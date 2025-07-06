local init_file = {
	FULL_PATH = nil,
	get_full_path = function(self)
		self.FULL_PATH = debug.getinfo(1, "S").source:sub(2)
	end,
}
init_file:get_full_path()

--[[
-- `src:get_dirs_inside`: each found dir is equivalent to each local plugin
--]]

local src = {
	FULL_PATH = nil,
	FOUND_DIRS = {},
	get_full_path = function(self)
		self.FULL_PATH = string.gsub(init_file.FULL_PATH, "init.lua", "")
	end,
	get_dirs_inside = function(self)
		local request_obj = vim.uv.fs_scandir(self.FULL_PATH)
		if request_obj then
			while true do
				local name, type = vim.uv.fs_scandir_next(request_obj)
				if not name then
					break
				else
					if type == "directory" then
						table.insert(self.FOUND_DIRS, self.FULL_PATH .. name)
					end
				end
			end
		end
	end,
}
src:get_full_path()
src:get_dirs_inside()

local local_plugins = {}
for _, plugin_path in ipairs(src.FOUND_DIRS) do
	table.insert(local_plugins, {
		dir = plugin_path,
		--lazy = true,
	})
end

return local_plugins
