return {
	"EvWilson/spelunk.nvim",
	dependencies = { "folke/snacks.nvim" },
	event = "VeryLazy",
	keys = {
		{
			"<leader>ja",
			function() require("config.spelunk").add_bookmark() end,
			desc = "Add bookmark",
		},
		{
			"<leader>jf",
			function() require("spelunk").search_marks() end,
			desc = "Find bookmarks",
		},
	},
	opts = {
		enable_persist = true,
		persist_by_git_branch = false,
		fuzzy_search_provider = "snacks",
		base_mappings = {
			toggle = "NONE",
			add = "NONE",
			delete = "NONE",
			next_bookmark = "NONE",
			prev_bookmark = "NONE",
			search_bookmarks = "NONE",
			search_current_bookmarks = "NONE",
			search_stacks = "NONE",
			change_line = "NONE",
		},
		window_mappings = {
			cursor_down = "NONE",
			cursor_up = "NONE",
			bookmark_down = "NONE",
			bookmark_up = "NONE",
			goto_bookmark = "NONE",
			goto_bookmark_hsplit = "NONE",
			goto_bookmark_vsplit = "NONE",
			change_line = "NONE",
			delete_bookmark = "NONE",
			next_stack = "NONE",
			previous_stack = "NONE",
			new_stack = "NONE",
			delete_stack = "NONE",
			edit_stack = "NONE",
			close = "NONE",
			help = "NONE",
		},
	},
	config = function(_, opts)
		require("spelunk").setup(opts)
		require("config.spelunk").setup()
	end,
}
