return {
	"gbprod/substitute.nvim",
	event = "VeryLazy",
	config = function()
		require("substitute").setup({})

		vim.keymap.set("n", "gx", function()
			require("substitute.exchange").operator()
		end, { desc = "Exchange operator" })
		vim.keymap.set("x", "x", function()
			require("substitute.exchange").visual()
		end, { desc = "Exchange visual selection" })
	end,
}
