return {
	"retran/meow.yarn.nvim",
	main = "meow.yarn",
	cmd = "MeowYarn",
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {
		window = {
			width = 0.95,
			height = 0.95,
			preview_height_ratio = 0.525,
		},
	},
	keys = {
		{ "<leader>yt", "<Cmd>MeowYarn type super<CR>", desc = "Type hierarchy: supertypes" },
		{ "<leader>yT", "<Cmd>MeowYarn type sub<CR>", desc = "Type hierarchy: subtypes" },
		{ "<localleader>ci", "<Cmd>MeowYarn call callers<CR>", desc = "Incoming calls" },
		{ "<localleader>co", "<Cmd>MeowYarn call callees<CR>", desc = "Outgoing calls" },
	},
}
