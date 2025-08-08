local M = {}

---Split string by pattern
---@param s string
---@param pattern string
---@return table<integer, string>
function M.splitString(s, pattern)
	local res = {}
	for match in string.gmatch(s:sub(-1, -1) == pattern and s or s .. pattern, "(.-)" .. pattern) do --`-` is non-greedy search, which stop after first found specified character
		if (match ~= nil) and (match ~= "") and (match ~= " ") then
			table.insert(res, match)
		end
	end

	return res
end

---Abbreviate home directory as `~`
---@param absoulute_path string
---@return string
function M.abbreviateHomeDir(absoulute_path)
	local home_dir = vim.uv.os_homedir()

	--return
	return home_dir and string.gsub(absoulute_path, home_dir, "~", 1) or absoulute_path
end

---@param path string
---@return table<integer, string>
---@return table<integer, string>
function M.scanDir(path)
	local dirs_names, files_names = {}, {}
	local dir_contents = vim.uv.fs_scandir(path)
	if dir_contents then
		while true do
			local name, type, _ = vim.uv.fs_scandir_next(dir_contents)
			if name then
				if type == "directory" then
					table.insert(dirs_names, name)
				elseif type == "file" then
					table.insert(files_names, name)
				end
			else
				break --stop the loop if no more file is found
			end
		end
	end

	return dirs_names, files_names
end

---@param bufnr integer
---@param delimiter string
function M:align2Words(bufnr, delimiter)
	--find the maximum length of first word of given list
	local first_word_of_lines = {}
	local max_length = 0
	for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)) do
		local tokens = self.splitString(line, delimiter)
		local actual_first_word_length = tokens[1]:sub(1, 1) == "*" and tokens[1]:len() or tokens[1]:len() + 1 --Due to omitted space char while splitting string so we neet to add 1 to words that don't start with "*"
		max_length = max_length >= actual_first_word_length and max_length or actual_first_word_length

		table.insert(first_word_of_lines, tokens[1])
	end

	--adding pads
	for row, word in pairs(first_word_of_lines) do
		local actual_word_length = word:sub(1, 1) == "*" and word:len() or word:len() + 1
		local length_diff = max_length - actual_word_length
		--vim.api.nvim_buf_set_text(
		--	bufnr,
		--	row - 1,
		--	word:len() + 1,
		--	row - 1,
		--	word:len() + 1,
		--	{ (" "):rep((length_diff > 0) and length_diff or 0) }
		--)
		vim.api.nvim_buf_set_text(
			bufnr,
			row - 1,
			0, --ADDITIONAL PLACES WILL BE ADDED ON THE LEFT if the number in decimal base exceed its limit, which is 9
			row - 1,
			0,
			{ (" "):rep((length_diff > 0) and length_diff or 0) }
		)
	end
end

---Highlight active instances(buffers)
---@param active_ins integer
---@param inactive_ins integer
---@param list table<integer, string>
function M.highlightActiveInstance(active_ins, inactive_ins, list)
	for row, value in ipairs(list) do
		local tokens = M.splitString(value, " ")
		if tonumber(tokens[1]) == active_ins then
			vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 1, { "*" }) -- the HOSTING_INDICATOR column is 0-beginning of the line-as default, change from colum 0 to 1 to replace, otherwise, it'll insert if specifying column 0 to 0
		elseif tonumber(tokens[1]:sub(2, -1)) == inactive_ins then
			vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 1, { " " })
		end
	end
end

---@param activated_abbreviated_venv_name string
function M:highlightActivatedVirtualEnvironment(activated_abbreviated_venv_name)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
	for row, line in ipairs(lines) do
		local tokens = self.splitString(line, " ")
		if tokens[1] == activated_abbreviated_venv_name then
			vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 1, { "*" })
		elseif tokens[1]:sub(1, 1) == "*" then
			vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 1, { " " })
		end
	end
end

return M
