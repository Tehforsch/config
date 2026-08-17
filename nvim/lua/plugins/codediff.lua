return {
	"esmuellert/codediff.nvim",
	pin = true,
	build = function(plugin)
		local patch = vim.fs.joinpath(vim.fn.stdpath("config"), "patches", "codediff-retarget-revisions.patch")
		local applied = vim.system({ "git", "apply", "--reverse", "--check", patch }, { cwd = plugin.dir }):wait()
		if applied.code == 0 then return end

		local result = vim.system({ "git", "apply", patch }, { cwd = plugin.dir, text = true }):wait()
		if result.code ~= 0 then error("Could not patch CodeDiff: " .. vim.trim(result.stderr or result.stdout)) end
	end,
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
