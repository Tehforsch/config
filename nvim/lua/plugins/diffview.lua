local function diff_between_refs()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local function get_git_refs()
		local refs = { "HEAD", "HEAD~1", "HEAD~2", "HEAD~3" }
		local handle = io.popen("git for-each-ref --format='%(refname:short)' refs/heads refs/remotes")
		if handle then
			for line in handle:lines() do
				table.insert(refs, line)
			end
			handle:close()
		end
		return refs
	end

	local first_ref = nil

	local function select_first_ref(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		if not selection then
			return
		end
		first_ref = selection[1]
		actions.close(prompt_bufnr)

		pickers
			.new({}, {
				prompt_title = "Select Second Ref (comparing with " .. first_ref .. ")",
				finder = finders.new_table({
					results = get_git_refs(),
				}),
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr2, map)
					actions.select_default:replace(function()
						local selection2 = action_state.get_selected_entry()
						local picker = action_state.get_current_picker(prompt_bufnr2)
						local prompt = picker:_get_prompt()
						actions.close(prompt_bufnr2)

						local second_ref
						if selection2 then
							second_ref = selection2[1]
						elseif prompt and prompt ~= "" then
							second_ref = prompt
						else
							return
						end
						vim.cmd("DiffviewOpen " .. first_ref .. ".." .. second_ref)
					end)
					return true
				end,
			})
			:find()
	end

	pickers
		.new({}, {
			prompt_title = "Select First Ref",
			finder = finders.new_table({
				results = get_git_refs(),
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					local picker = action_state.get_current_picker(prompt_bufnr)
					local prompt = picker:_get_prompt()

					if selection then
						first_ref = selection[1]
					elseif prompt and prompt ~= "" then
						first_ref = prompt
					else
						return
					end

					actions.close(prompt_bufnr)

					pickers
						.new({}, {
							prompt_title = "Select Second Ref (comparing with " .. first_ref .. ")",
							finder = finders.new_table({
								results = get_git_refs(),
							}),
							sorter = conf.generic_sorter({}),
							attach_mappings = function(prompt_bufnr2, map)
								actions.select_default:replace(function()
									local selection2 = action_state.get_selected_entry()
									local picker2 = action_state.get_current_picker(prompt_bufnr2)
									local prompt2 = picker2:_get_prompt()
									actions.close(prompt_bufnr2)

									local second_ref
									if selection2 then
										second_ref = selection2[1]
									elseif prompt2 and prompt2 ~= "" then
										second_ref = prompt2
									else
										return
									end
									vim.cmd("DiffviewOpen " .. first_ref .. ".." .. second_ref)
								end)
								return true
							end,
						})
						:find()
				end)
				return true
			end,
		})
		:find()
end

return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gd", diff_between_refs, desc = "Diff between refs" },
		{ "<leader>gD", "<cmd>DiffviewOpen main<cr>", desc = "Diff with main" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch history" },
		{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
	},
	opts = function()
		local actions = require("diffview.actions")
		return {
			enhanced_diff_hl = true,
			view = {
				merge_tool = {
					layout = "diff3_mixed",
				},
			},
			keymaps = {
				view = {
					-- The `view` bindings are active in the diff buffers, only when the current
					-- tabpage is a Diffview.
					{ "n", "<localleader>fn", actions.select_next_entry, { desc = "Open the diff for the next file" } },
					{ "n", "<localleader>fp", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
					{ "n", "<localleader>f0", actions.select_first_entry, { desc = "Open the diff for the first file" } },
					{ "n", "<localleader>f$", actions.select_last_entry, { desc = "Open the diff for the last file" } },
					{ "n", "<localleader>vf", actions.focus_files, { desc = "Bring focus to the file panel" } },
					{ "n", "<localleader>vt", actions.toggle_files, { desc = "Toggle the file panel." } },
					{ "n", "<localleader>vc", actions.cycle_layout, { desc = "Cycle through available layouts." } },
					{ "n", "<localleader>cn", actions.next_conflict, { desc = "In the merge-tool: jump to the next conflict" } },
					{ "n", "<localleader>cp", actions.prev_conflict, { desc = "In the merge-tool: jump to the previous conflict" } },
					{ "n", "<localleader>co", actions.conflict_choose("ours"), { desc = "Choose the OURS version of a conflict" } },
					{ "n", "<localleader>ct", actions.conflict_choose("theirs"), { desc = "Choose the THEIRS version of a conflict" } },
					{ "n", "<localleader>cb", actions.conflict_choose("base"), { desc = "Choose the BASE version of a conflict" } },
					{ "n", "<localleader>ca", actions.conflict_choose("all"), { desc = "Choose all the versions of a conflict" } },
					{ "n", "<localleader>cx", actions.conflict_choose("none"), { desc = "Delete the conflict region" } },
				},
				file_panel = {
					{ "n", "j", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
					{ "n", "<down>", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
					{ "n", "k", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
					{ "n", "<up>", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
					{ "n", "<cr>", actions.select_entry, { desc = "Open the diff for the selected entry" } },
					{ "n", "<2-LeftMouse>", actions.select_entry, { desc = "Open the diff for the selected entry" } },
					{ "n", "s", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
					{ "n", "X", actions.restore_entry, { desc = "Restore entry to the state on the left side" } },
					{ "n", "zo", actions.open_fold, { desc = "Expand fold" } },
					{ "n", "zc", actions.close_fold, { desc = "Collapse fold" } },
					{ "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
					{ "n", "zO", actions.open_all_folds, { desc = "Expand all folds" } },
					{ "n", "zC", actions.close_all_folds, { desc = "Collapse all folds" } },
				},
			},
			hooks = {
				diff_buf_read = function(bufnr)
					vim.opt_local.scrollbind = true
					vim.opt_local.cursorbind = true
				end,
			},
		}
	end,
}
