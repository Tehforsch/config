return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
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

			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			local Hydra = require("hydra")
			Hydra({
				name = "Harpoon",
				mode = "n",
				body = "<leader>j",
				hint = [[
 _a_: add   _m_: menu   _f_: telescope   _d_: delete
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
							toggle_telescope(harpoon:list())
						end,
						{ exit = true, desc = "telescope" },
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
