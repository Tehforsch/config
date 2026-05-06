return {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	config = function()
		require("Comment").setup({
			pre_hook = function()
				if vim.bo.filetype == "toml" then
					return "# %s"
				end
			end,
			toggler = {
				line = "gcc",
				block = "gbc",
			},
			opleader = {
				line = "gc",
				block = "gb",
			},
			mappings = {
				basic = true,
				extra = true,
			},
		})

		vim.keymap.set("n", "<C-e>", function()
			return vim.api.nvim_get_vvar("count") == 0 and "<Plug>(comment_toggle_linewise_current)"
				or "<Plug>(comment_toggle_linewise_count)"
		end, { expr = true, desc = "Comment line" })
	end,
}
