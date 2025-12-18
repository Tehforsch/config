return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = {
			follow_files = true,
		},
		attach_to_untracked = true,
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
			ignore_whitespace = false,
		},
		sign_priority = 6,
		update_debounce = 100,
		max_file_length = 40000,
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			vim.keymap.set("n", "<leader>gb", function()
				gs.toggle_current_line_blame()
			end, { buffer = bufnr, desc = "Toggle git blame" })

			local Hydra = require("hydra")
			Hydra({
				name = "Git hunk navigation",
				mode = "n",
				body = "<leader>g",
				hint = [[
 _n_: next hunk   _p_: prev hunk
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
					{
						"n",
						function()
							if vim.wo.diff then
								return "]c"
							end
							vim.schedule(function()
								gs.next_hunk()
							end)
							return "<Ignore>"
						end,
						{ expr = true, desc = "next hunk" },
					},
					{
						"p",
						function()
							if vim.wo.diff then
								return "[c"
							end
							vim.schedule(function()
								gs.prev_hunk()
							end)
							return "<Ignore>"
						end,
						{ expr = true, desc = "prev hunk" },
					},
					{ "<Esc>", nil, { exit = true } },
					{ "b", gs.toggle_current_line_blame, { exit = true, desc = "toggle blame" } },
				},
			})
		end,
	},
}
