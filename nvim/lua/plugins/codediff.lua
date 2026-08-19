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
	init = function()
		local refresh_generation = {}
		local function map_review_keys(tabpage)
			vim.schedule(function()
				if not vim.api.nvim_tabpage_is_valid(tabpage) then return end
				local lifecycle = require("codediff.ui.lifecycle")
				if not lifecycle.get_session(tabpage) then return end
				lifecycle.set_tab_keymap(tabpage, "n", "s", function() require("config.jj").squash_current_hunk() end, { desc = "Squash hunk into @-" })
				lifecycle.set_tab_keymap(tabpage, "n", "r", function() require("config.jj").add_review_note() end, { desc = "Add review note" })
				lifecycle.set_tab_keymap(tabpage, "x", "r", function() require("config.jj").add_review_note(true) end, { desc = "Add review note for selection" })
				lifecycle.set_tab_keymap(tabpage, "n", "H", "<C-w>h", { desc = "Focus left window" })
				lifecycle.set_tab_keymap(tabpage, "n", "L", "<C-w>l", { desc = "Focus right window" })
			end)
		end
		local function refresh_review_keys(tabpage)
			refresh_generation[tabpage] = (refresh_generation[tabpage] or 0) + 1
			local generation = refresh_generation[tabpage]
			map_review_keys(tabpage)
			for _, delay in ipairs({ 50, 200, 500 }) do
				vim.defer_fn(function()
					if refresh_generation[tabpage] == generation then map_review_keys(tabpage) end
				end, delay)
			end
		end

		vim.api.nvim_create_autocmd("User", {
			pattern = { "CodeDiffOpen", "CodeDiffFileSelect" },
			callback = function(event)
				local tabpage = event.data and event.data.tabpage
				if tabpage then refresh_review_keys(tabpage) end
			end,
		})
		vim.api.nvim_create_autocmd("BufEnter", {
			callback = function()
				if package.loaded["codediff.ui.lifecycle"] then refresh_review_keys(vim.api.nvim_get_current_tabpage()) end
			end,
		})
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
				next_hunk = "n",
				prev_hunk = "p",
				next_file = "J",
				prev_file = "K",
				-- These actions operate on Git's index/working tree, not JJ revisions.
				stage_hunk = false,
				unstage_hunk = false,
				discard_hunk = false,
			},
		},
	},
}
