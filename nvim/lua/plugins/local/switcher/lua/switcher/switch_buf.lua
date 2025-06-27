local utils = require("switcher.utils")

-- window

---@param bufnr number
---@return number|nil
local function verifyBuf(bufnr)
	if vim.api.nvim_buf_is_loaded(bufnr) then -- loaded
		local bufInfo = vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr))
		if bufInfo and bufInfo.type == "file" then -- existing
			return bufnr
		end
	else
		return nil
	end
end

---@return table<number>
local function getVerifiedBufs()
	local res = {}
	for _, value in ipairs(vim.api.nvim_list_bufs()) do
		local bufnr = verifyBuf(value)
		if bufnr then
			table.insert(res, bufnr)
		end
	end

	return res
end

---@param existing_bufs table<number>
---@return table<number, boolean>
---@return table<number, number>
local function getHostedBufs(existing_bufs)
    local windows_hosting_bufs = {}
	for _, value in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(value) then
			local bufnr = verifyBuf(vim.api.nvim_win_get_buf(value))
			if bufnr then
                windows_hosting_bufs[value] = bufnr
			end
		end
	end

	local res_dict = {} -- using Dict-like (key: buffer's ID, value: true|false), true if being hosted, otherwise, false
    local hosted_bufs = vim.tbl_values(windows_hosting_bufs)
	if hosted_bufs then
		for _, value in ipairs(existing_bufs) do
			if vim.tbl_contains(hosted_bufs, value) then
				res_dict[value] = true
			else
				res_dict[value] = false
			end
		end
	end

	return res_dict, windows_hosting_bufs
end

---@param hosted_bufnrs_dict table<number, boolean>
---@return table<string>
local function formatOutput(hosted_bufnrs_dict)
	local res_list = {}
	for key, value in pairs(hosted_bufnrs_dict) do
		local path = string.gsub(vim.api.nvim_buf_get_name(key), vim.fn.getcwd(), ".")
		local hosting_indicator = value and "*" or " " -- single line if-else
		table.insert(res_list, hosting_indicator .. tostring(key) .. " " .. path)
	end

	return res_list
end

-- TODO: modify one shared variable
local formatted_output_list = formatOutput(getHostedBufs(getVerifiedBufs()))
for _, value in ipairs(formatted_output_list) do
	print(value)
end

return {
	verifyBuf = verifyBuf,
	getVerifiedBufs = getVerifiedBufs,
	getHostedBufs = getHostedBufs,
	formatOutput = formatOutput,
}
