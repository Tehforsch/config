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
    vim.keymap.set("x", "p", function()
        vim.cmd('normal! "_d')
        local keys = vim.api.nvim_replace_termcodes("<Plug>(YankyPutBefore)", true, false, true)
        vim.api.nvim_feedkeys(keys, "n", false)
    end)
    vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
		vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
		vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
	end,
}
