return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = {
			follow_files = true,
		},
		attach_to_untracked = true,
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
			ignore_whitespace = false,
		},
		sign_priority = 6,
		update_debounce = 100,
		max_file_length = 40000,
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			vim.keymap.set("n", "<leader>gb", function()
				gs.toggle_current_line_blame()
			end, { buffer = bufnr, desc = "Toggle git blame" })

			local function browse_revision_files()
				local pickers = require("telescope.pickers")
				local finders = require("telescope.finders")
				local conf = require("telescope.config").values
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")
				local previewers = require("telescope.previewers")

				local function get_git_refs()
					local refs = {}
					local branches = vim.fn.systemlist("git branch -a --format='%(refname:short)'")
					local tags = vim.fn.systemlist("git tag")
					local recent_commits = vim.fn.systemlist("git log --pretty=format:'%h %s' -n 20")

					for _, branch in ipairs(branches) do
						table.insert(refs, { type = "branch", ref = branch, display = "  " .. branch })
					end
					for _, tag in ipairs(tags) do
						table.insert(refs, { type = "tag", ref = tag, display = "  " .. tag })
					end
					for _, commit in ipairs(recent_commits) do
						local hash, message = commit:match("^(%S+)%s+(.*)$")
						if hash then
							table.insert(refs, { type = "commit", ref = hash, display = "  " .. hash .. " " .. message })
						end
					end

					return refs
				end

				local function browse_files_at_revision(rev)
					local files = vim.fn.systemlist("git ls-tree -r --name-only " .. rev)
					if vim.v.shell_error ~= 0 then
						vim.notify("Failed to list files at revision " .. rev, vim.log.levels.ERROR)
						return
					end

					pickers
						.new({}, {
							prompt_title = "Files at " .. rev,
							finder = finders.new_table({
								results = files,
							}),
							sorter = conf.generic_sorter({}),
							previewer = previewers.new_termopen_previewer({
								get_command = function(entry)
									return { "git", "show", rev .. ":" .. entry.value }
								end,
							}),
							attach_mappings = function(prompt_bufnr, map)
								actions.select_default:replace(function()
									actions.close(prompt_bufnr)
									local selection = action_state.get_selected_entry()
									local file_content = vim.fn.systemlist("git show " .. rev .. ":" .. selection.value)

									local buf = vim.api.nvim_create_buf(false, true)
									vim.api.nvim_buf_set_lines(buf, 0, -1, false, file_content)
									vim.api.nvim_buf_set_name(buf, selection.value .. " @ " .. rev)
									vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
									vim.api.nvim_buf_set_option(buf, "modifiable", false)

									local ft = vim.filetype.match({ filename = selection.value })
									if ft then
										vim.api.nvim_buf_set_option(buf, "filetype", ft)
									end

									vim.api.nvim_set_current_buf(buf)
								end)
								return true
							end,
						})
						:find()
				end

				local refs = get_git_refs()
				if #refs == 0 then
					vim.notify("No git refs found", vim.log.levels.WARN)
					return
				end

				pickers
					.new({}, {
						prompt_title = "Browse Revision",
						finder = finders.new_table({
							results = refs,
							entry_maker = function(entry)
								return {
									value = entry.ref,
									display = entry.display,
									ordinal = entry.display,
								}
							end,
						}),
						sorter = conf.generic_sorter({}),
						attach_mappings = function(prompt_bufnr, map)
							actions.select_default:replace(function()
								actions.close(prompt_bufnr)
								local selection = action_state.get_selected_entry()
								browse_files_at_revision(selection.value)
							end)
							return true
						end,
					})
					:find()
			end

			vim.keymap.set("n", "<leader>gf", browse_revision_files, { buffer = bufnr, desc = "Browse files at revision" })

			local Hydra = require("hydra")
			Hydra({
				name = "Git hunk navigation",
				mode = "n",
				body = "<leader>g",
				hint = [[
 _n_: next hunk   _p_: prev hunk
]],
				config = {
					color = "pink",
					invoke_on_body = false,
					hint = {
						float_opts = {
							border = "rounded",
						},
						position = "bottom",
					},
				},
				heads = {
					{
						"n",
						function()
							if vim.wo.diff then
								return "]c"
							end
							vim.schedule(function()
								gs.next_hunk()
							end)
							return "<Ignore>"
						end,
						{ expr = true, desc = "next hunk" },
					},
					{
						"p",
						function()
							if vim.wo.diff then
								return "[c"
							end
							vim.schedule(function()
								gs.prev_hunk()
							end)
							return "<Ignore>"
						end,
						{ expr = true, desc = "prev hunk" },
					},
					{ "<Esc>", nil, { exit = true } },
					{ "b", gs.toggle_current_line_blame, { exit = true, desc = "toggle blame" } },
				},
			})
		end,
	},
}
