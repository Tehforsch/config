return {
	"kylechui/nvim-surround",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({
			keymaps = {
				insert = "<C-g>s",
				insert_line = "<C-g>S",
				normal = "s",
				normal_cur = "ss",
				normal_line = "S",
				normal_cur_line = "SS",
				visual = "S",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
				change_line = "cS",
			},
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
			},
		})
	end,
}
