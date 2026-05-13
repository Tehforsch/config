local function diff_between_refs()
	local function get_refs()
		local refs = { "HEAD", "HEAD~1", "HEAD~2", "HEAD~3" }
		local handle = io.popen("git for-each-ref --format='%(refname:short)' refs/heads refs/remotes")
		if handle then
			for line in handle:lines() do
				table.insert(refs, line)
			end
			handle:close()
		end
		return vim.tbl_map(function(r) return { text = r } end, refs)
	end

	Snacks.picker.pick({
		title = "Select First Ref",
		items = get_refs(),
		confirm = function(p1, item)
			p1:close()
			local first_ref = item.text
			Snacks.picker.pick({
				title = "Select Second Ref (vs " .. first_ref .. ")",
				items = get_refs(),
				confirm = function(p2, item2)
					p2:close()
					vim.cmd("DiffviewOpen " .. first_ref .. ".." .. item2.text)
				end,
			})
		end,
	})
end

local function make_diff_keymaps(actions)
	local nav = {
		{ "n", "<localleader>fn", actions.select_next_entry, { desc = "Open the diff for the next file" } },
		{ "n", "<localleader>fp", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
		{ "n", "<localleader>f0", actions.select_first_entry, { desc = "Open the diff for the first file" } },
		{ "n", "<localleader>f$", actions.select_last_entry, { desc = "Open the diff for the last file" } },
		{ "n", "<localleader>vf", actions.focus_files, { desc = "Bring focus to the file panel" } },
		{ "n", "<localleader>vt", actions.toggle_files, { desc = "Toggle the file panel." } },
		{ "n", "<localleader>vc", actions.cycle_layout, { desc = "Cycle through available layouts." } },
		{ "n", "<localleader>cn", actions.next_conflict, { desc = "Jump to the next conflict" } },
		{ "n", "<localleader>cp", actions.prev_conflict, { desc = "Jump to the previous conflict" } },
		{ "n", "<localleader>co", actions.conflict_choose("ours"), { desc = "Choose the OURS version of a conflict" } },
		{ "n", "<localleader>ct", actions.conflict_choose("theirs"), { desc = "Choose the THEIRS version of a conflict" } },
		{ "n", "<localleader>cb", actions.conflict_choose("base"), { desc = "Choose the BASE version of a conflict" } },
		{ "n", "<localleader>ca", actions.conflict_choose("all"), { desc = "Choose all the versions of a conflict" } },
		{ "n", "<localleader>cx", actions.conflict_choose("none"), { desc = "Delete the conflict region" } },
	}
	return nav
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
		{ "<leader>gm", "<cmd>DiffviewOpen -m<cr>", desc = "Open merge/conflicts" },
		{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
	},
	opts = function()
		local actions = require("diffview.actions")
		local keymaps = make_diff_keymaps(actions)
		return {
			enhanced_diff_hl = true,
			view = {
				merge_tool = {
					layout = "diff3_mixed",
				},
			},
			keymaps = {
				view = keymaps,
				diff2 = keymaps,
				diff3 = keymaps,
				diff4 = keymaps,
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
