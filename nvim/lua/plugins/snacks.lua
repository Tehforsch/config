return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		input = { enabled = true },
		picker = {
			enabled = true,
			ui_select = true,
			sources = {
				files = {
					exclude = { "*.ogg", "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.mp3", "*.wav", "*.flac", "*.svg" },
				},
			},
			layout = {
				layout = {
					box = "vertical",
					width = 0.95,
					height = 0.92,
					border = true,
					title = "{title} {live} {flags}",
					title_pos = "center",
					{ win = "input", height = 1, border = "bottom" },
					{ win = "list", height = 0.25, border = "none" },
					{ win = "preview", title = "{preview}", border = "top" },
				},
			},
		},
	},
}
