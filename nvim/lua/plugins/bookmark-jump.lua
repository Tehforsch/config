return {
	dir = vim.fn.stdpath("config") .. "/local/bookmark-jump.nvim",
	name = "bookmark-jump.nvim",
	dependencies = { "folke/snacks.nvim" },
	keys = {
		{
			"<leader>ja",
			function() require("bookmark-jump").add() end,
			desc = "Add bookmark",
		},
		{
			"<leader>jf",
			function() require("bookmark-jump").find() end,
			desc = "Find bookmarks",
		},
	},
}
