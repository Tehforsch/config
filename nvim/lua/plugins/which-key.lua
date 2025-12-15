return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({
				delay = 500,
				plugins = {
					marks = true,
					registers = true,
					spelling = {
						enabled = false,
					},
					presets = {
						operators = false,
						motions = false,
						text_objects = false,
						windows = false,
						nav = false,
						z = false,
						g = false,
					},
				},
			})

			wk.add({
				{ "<leader>f", group = "file" },
				{ "<leader>p", group = "project" },
				{ "<leader>g", group = "git" },
				{ "<leader>e", group = "editor" },
				{ "<leader>u", group = "ui" },
				{ "<leader>h", group = "history" },
				{ "<localleader>", group = "local" },
			})
		end,
	},
}
