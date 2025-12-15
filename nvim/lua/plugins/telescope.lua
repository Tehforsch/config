return {
	{
		"nvim-telescope/telescope.nvim",
		-- Use master for now due to deprecated commands
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					prompt_prefix = "> ",
					selection_caret = "> ",
					path_display = { "truncate" },
					file_ignore_patterns = {
						"node_modules",
						".git/",
						"target/",
						"dist/",
						"build/",
						"%.png",
						"%.jpg",
						"%.jpeg",
						"%.gif",
						"%.pdf",
					},
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<Esc>"] = actions.close,
						},
						n = {
							["q"] = actions.close,
						},
					},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob",
						"!.git/",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
						find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
					},
					live_grep = {
						additional_args = function()
							return { "--hidden" }
						end,
					},
					buffers = {
						sort_mru = true,
						mappings = {
							i = {
								["<C-d>"] = actions.delete_buffer,
							},
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
		end,
	},
}
