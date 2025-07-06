local switch_buf = require("switcher.switch_buf")
local function setup(_)
	vim.api.nvim_create_user_command("SwitchBuf", function()
		switch_buf:init()
	end, {})
end

return {
	setup = setup,
}
