--# check if a table is a list or not
local function is_list(candidate)
    for key, _ in pairs(candidate) do
        if not tonumber(key) then
            return false
        end
    end

    return true
end

--# unpack a dictionary-like into seprate keys and values
local function unpack_dict(dict)
    local keys, values = {}, {}
    if not is_list(dict) then
        for key, value in pairs(dict) do
            table.insert(keys, key)
            table.insert(values, value)
        end
    end

    return keys, values
end

--# returned package
local M = {
    is_list = is_list,
    unpack_dict = unpack_dict,
}

return M
