return {
	"algmyr/vcsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"algmyr/vclib.nvim",
		"lewis6991/async.nvim",
	},
	keys = {
		{
			"<leader>gb",
			function() require("config.jj").toggle_blame() end,
			desc = "Toggle JJ blame",
		},
		{
			"<leader>gn",
			function() require("vcsigns.actions").hunk_next(0, vim.v.count1) end,
			desc = "Next hunk",
		},
		{
			"<leader>gp",
			function() require("vcsigns.actions").hunk_prev(0, vim.v.count1) end,
			desc = "Previous hunk",
		},
		{
			"<leader>gf",
			function() require("config.jj").pick_hunks() end,
			desc = "Browse working-copy hunks",
		},
		{
			"<leader>gs",
			function() require("config.jj").squash_current_hunk() end,
			desc = "Squash hunk into @-",
		},
	},
	opts = {
		-- Show the changes introduced by @ (that is, compare @- to @).
		target_commit = 0,
		show_delete_count = false,
		signs = {
			text = {
				add = "│",
				change = "│",
				delete_below = "_",
				delete_above = "‾",
				delete_above_below = "~",
			},
			priority = 6,
		},
	},
}
