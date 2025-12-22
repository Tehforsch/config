return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			overrides = function(colors)
				local theme = colors.theme
				return {
					["@comment.documentation"] = { fg = theme.syn.special1, italic = true },
					["@string.documentation"] = { fg = theme.syn.special1, italic = true },
				}
			end,
		})
		vim.cmd("colorscheme kanagawa")
	end,
}
