-- Terminal-related functionality for SPC r command
-- Calls the existing runLastCommandInTerminalToTheRight.sh script

local script_path = vim.fn.expand("~/projects/config/scripts/runLastCommandInTerminalToTheRight.sh")

local function run_command_in_terminal_to_right()
	-- Save the current file
	vim.cmd("write")

	-- Run the bash script
	vim.fn.system(script_path)
end

vim.keymap.set(
	"n",
	"<leader>r",
	run_command_in_terminal_to_right,
	{ desc = "Save and run last command in right terminal" }
)

return {}
