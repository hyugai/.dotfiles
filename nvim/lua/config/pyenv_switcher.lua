-- choosing python's envs (support Miniconda first)
local pyenv = {
	CURRENT_VENV = nil,
    -- find miniconda3's directory
	get_current_venv = function(self) end,
}

local buffer = {}
local window = {}
