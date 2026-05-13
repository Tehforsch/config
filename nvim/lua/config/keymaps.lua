local keymap = vim.keymap.set

local command_history = function()
	Snacks.picker.command_history()
end

keymap("n", "<leader>^", "<C-^>", { desc = "Toggle to last buffer" })

keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlighting" })

keymap("n", "<leader>x", function()
	Snacks.picker.commands()
end, { desc = "Commands" })

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
	Snacks.picker.files()
end, { desc = "Find file" })

keymap("n", "<leader>bf", function()
	Snacks.picker.buffers()
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
	local projects_dir = vim.fn.expand("~/projects")
	local dirs = vim.fn.globpath(projects_dir, "*", false, true)
	dirs = vim.tbl_filter(function(d) return vim.fn.isdirectory(d) == 1 end, dirs)
	Snacks.picker.pick({
		title = "Projects",
		format = "text",
		layout = "select",
		items = vim.tbl_map(function(d)
			return { text = vim.fn.fnamemodify(d, ":t"), value = d }
		end, dirs),
		confirm = function(picker, item)
			picker:close()
			vim.cmd.cd(item.value)
			Snacks.picker.files()
		end,
	})
end, { desc = "Switch project" })

keymap("n", "<leader>pa", function()
	Snacks.picker.grep()
end, { desc = "Search in project" })

keymap("n", "<localleader>s", function()
	Snacks.picker.lsp_symbols()
end, { desc = "Search symbols in file" })
keymap("n", "<localleader>S", function()
	Snacks.picker.lsp_workspace_symbols()
end, { desc = "Search symbols in workspace" })
keymap("n", "<localleader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })

keymap("n", "<leader>h", function()
	Snacks.picker.resume()
end, { desc = "Resume last search" })
