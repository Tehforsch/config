local keymap = vim.keymap.set

local command_history = function()
	require("telescope.builtin").command_history()
end

keymap("n", "<leader>^", "<C-^>", { desc = "Toggle to last buffer" })

keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlighting" })

keymap("n", "<leader>x", command_history, { desc = "Command history" })
keymap("n", ":", command_history, { desc = "Command history" })

keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("x", "p", '"_dP', { desc = "Paste without yanking" })

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
 _n_: next   _p_: prev
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
		{ "p", ":bprevious<CR>", { desc = "previous buffer" } },
		{ "<Esc>", nil, { exit = true } },
	},
})

keymap("n", "<leader>pf", function()
	require("telescope").extensions.projects.projects()
end, { desc = "Switch project" })

keymap("n", "<leader>pa", function()
	require("telescope.builtin").live_grep()
end, { desc = "Search in project" })

keymap("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })

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
