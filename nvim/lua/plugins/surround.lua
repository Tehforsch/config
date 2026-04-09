return {
	"kylechui/nvim-surround",
	version = "*",
	event = "VeryLazy",
	init = function()
		vim.g.nvim_surround_no_mappings = true
	end,
	config = function()
		require("nvim-surround").setup({
			surrounds = {
				["&"] = {
					add = { "&", "" },
					find = "&.-",
					delete = "^(&)().-()()$",
				},
				["f"] = {
					add = function()
						local func_name = require("nvim-surround.config").get_input("Function name: ")
						if func_name then
							return { { func_name .. "(" }, { ")" } }
						end
					end,
					find = "[%w_]+%b()",
					delete = "^([%w_]+%()().-(%))()$",
				},
				["s"] = {
					add = { "Some(", ")" },
					find = "Some%b()",
					delete = "^(Some%()().-(%))()$",
				},
				["o"] = {
					add = { "Ok(", ")" },
					find = "Ok%b()",
					delete = "^(Ok%()().-(%))()$",
				},
			},
		})

		vim.keymap.set("i", "<C-g>s", "<Plug>(nvim-surround-insert)")
		vim.keymap.set("i", "<C-g>S", "<Plug>(nvim-surround-insert-line)")
		vim.keymap.set("n", "s", "<Plug>(nvim-surround-normal)")
		vim.keymap.set("n", "ss", "<Plug>(nvim-surround-normal-cur)")
		vim.keymap.set("n", "S", "<Plug>(nvim-surround-normal-line)")
		vim.keymap.set("n", "SS", "<Plug>(nvim-surround-normal-cur-line)")
		vim.keymap.set("x", "s", "<Plug>(nvim-surround-visual)")
		vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)")
		vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)")
		vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)")
		vim.keymap.set("n", "cS", "<Plug>(nvim-surround-change-line)")
	end,
}
