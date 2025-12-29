local keymap = vim.keymap.set

local command_history = function()
	require("telescope.builtin").command_history()
end

keymap("n", "<leader>^", "<C-^>", { desc = "Toggle to last buffer" })

keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlighting" })

keymap("n", "<leader>x", function()
	require("telescope.builtin").commands()
end, { desc = "Commands" })
keymap("n", ":", command_history, { desc = "Command history" })

keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

keymap("n", "<C-o>", "<C-o>zzzv", { desc = "Jump back (centered)" })
keymap("n", "<C-i>", "<C-i>zzzv", { desc = "Jump forward (centered)" })

keymap("n", "ga", "ea", { desc = "Append at end of word" })
keymap("n", "gi", "bi", { desc = "Insert at beginning of word" })

keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

keymap("n", "<leader>s", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Find file" })

keymap("n", "<leader>bf", function()
	require("telescope.builtin").buffers()
end, { desc = "Switch buffer" })

-- Buffer navigation hydra
local Hydra = require("hydra")
Hydra({
	name = "Buffer navigation",
	mode = "n",
	body = "<leader>b",
	hint = [[
 _n_: next   _p_: prev   _d_: delete   _q_:quit
]],
	config = {
		color = "pink",
		invoke_on_body = false,
		hint = {
			float_opts = {
				border = "rounded",
			},
			position = "bottom",
		},
	},
	heads = {
		{ "n", ":bnext<CR>", { desc = "next buffer" } },
		{ "d", ":bd<CR>", { desc = "delete buffer" } },
		{ "p", ":bprevious<CR>", { desc = "previous buffer" } },
		{ "q", nil, { exit = true } },
		{ "<Esc>", nil, { exit = true } },
	},
})

keymap("n", "<leader>pf", function()
	require("telescope").extensions.projects.projects()
end, { desc = "Switch project" })

keymap("n", "<leader>pa", function()
	local builtin = require("telescope.builtin")
	local action_state = require("telescope.actions.state")
	local actions = require("telescope.actions")
	local conf = require("telescope.config").values

	local ignore_enabled = true

	local function toggle_ignore(prompt_bufnr)
		local picker = action_state.get_current_picker(prompt_bufnr)
		local prompt = picker:_get_prompt()

		ignore_enabled = not ignore_enabled

		actions.close(prompt_bufnr)

		local additional_args = {}
		if not ignore_enabled then
			additional_args = { "--no-ignore", "--glob", "!.git/" }
		end

		builtin.live_grep({
			default_text = prompt,
			additional_args = function()
				return additional_args
			end,
			attach_mappings = function(new_prompt_bufnr, map)
				map("i", "<Space>", function()
					local keys = vim.api.nvim_replace_termcodes(".*", true, false, true)
					vim.api.nvim_feedkeys(keys, "n", false)
				end)

				map("n", "<C-i>", function()
					toggle_ignore(new_prompt_bufnr)
				end)
				map("i", "<C-i>", function()
					toggle_ignore(new_prompt_bufnr)
				end)

				return true
			end,
		})
	end

	builtin.live_grep({
		attach_mappings = function(prompt_bufnr, map)
			map("i", "<Space>", function()
				local keys = vim.api.nvim_replace_termcodes(".*", true, false, true)
				vim.api.nvim_feedkeys(keys, "n", false)
			end)

			map("n", "<C-i>", function()
				toggle_ignore(prompt_bufnr)
			end)
			map("i", "<C-i>", function()
				toggle_ignore(prompt_bufnr)
			end)

			return true
		end,
	})
end, { desc = "Search in project" })

keymap("n", "<localleader>s", function()
	require("telescope.builtin").lsp_document_symbols()
end, { desc = "Search symbols in file" })
keymap("n", "<localleader>S", function()
	require("telescope.builtin").lsp_dynamic_workspace_symbols()
end, { desc = "Search symbols in workspace" })
keymap("n", "<localleader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Search history (SPC h)
keymap("n", "<leader>h", function()
	require("telescope.builtin").resume()
end, { desc = "Resume last search" })
