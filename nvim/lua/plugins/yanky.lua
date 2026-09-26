return {
	"gbprod/yanky.nvim",
	event = "VeryLazy",
	config = function()
		require("yanky").setup({
			ring = {
				history_length = 100,
				storage = "shada",
			},
		})

		vim.keymap.set("n", "p", "<Plug>(YankyPutAfter)")
		vim.keymap.set("x", "p", "<Plug>(YankyPutBefore)")
		vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
		vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
		vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
	end,
}
