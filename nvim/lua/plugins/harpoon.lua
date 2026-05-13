return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvimtools/hydra.nvim",
		},
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
				},
			})

			local function toggle_picker(harpoon_files)
				local items = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(items, { text = item.value, file = item.value })
				end
				Snacks.picker.pick({
					title = "Harpoon",
					items = items,
					preview = "file",
					confirm = function(picker, item)
						picker:close()
						vim.cmd.edit(item.file)
					end,
				})
			end

			local Hydra = require("hydra")
			Hydra({
				name = "Harpoon",
				mode = "n",
				body = "<leader>j",
				hint = [[
 _a_: add   _m_: menu   _f_: picker   _d_: delete
 _1_ _2_ _3_ _4_: select
 _n_: next   _p_: prev
]],
				config = {
					color = "pink",
					invoke_on_body = true,
					hint = {
						float_opts = {
							border = "rounded",
						},
						position = "bottom",
					},
				},
				heads = {
					{
						"a",
						function()
							harpoon:list():add()
						end,
						{ exit = true, desc = "add file" },
					},
					{
						"m",
						function()
							harpoon.ui:toggle_quick_menu(harpoon:list())
						end,
						{ exit = true, desc = "toggle menu" },
					},
					{
						"f",
						function()
							toggle_picker(harpoon:list())
						end,
						{ exit = true, desc = "picker" },
					},
					{
						"d",
						function()
							harpoon:list():remove()
						end,
						{ exit = true, desc = "delete current file" },
					},
					{
						"1",
						function()
							harpoon:list():select(1)
						end,
						{ desc = "file 1" },
					},
					{
						"2",
						function()
							harpoon:list():select(2)
						end,
						{ desc = "file 2" },
					},
					{
						"3",
						function()
							harpoon:list():select(3)
						end,
						{ desc = "file 3" },
					},
					{
						"4",
						function()
							harpoon:list():select(4)
						end,
						{ desc = "file 4" },
					},
					{
						"n",
						function()
							harpoon:list():next()
						end,
						{ desc = "next file" },
					},
					{
						"p",
						function()
							harpoon:list():prev()
						end,
						{ desc = "prev file" },
					},
					{ "q", nil, { exit = true, desc = "quit" } },
					{ "<Esc>", nil, { exit = true, desc = "quit" } },
				},
			})
		end,
	},
}
