return {
	"esmuellert/codediff.nvim",
	cmd = "CodeDiff",
	keys = {
		{
			"<leader>gd",
			function() require("config.jj").pick_diff_source() end,
			desc = "Review diff to @",
		},
	},
	opts = {
		diff = {
			layout = "side-by-side",
			cycle_hunks_across_files = false,
		},
		explorer = {
			initial_focus = "explorer",
		},
		keymaps = {
			view = {
				next_hunk = "<leader>gn",
				prev_hunk = "<leader>gp",
				-- These actions operate on Git's index/working tree, not JJ revisions.
				stage_hunk = false,
				unstage_hunk = false,
				discard_hunk = false,
			},
		},
	},
}
