local keymap = vim.keymap.set

keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>^", "<C-^>", { desc = "Toggle to last buffer" })

keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlighting" })

keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

keymap("x", "p", '"_dP', { desc = "Paste without yanking" })

-- File operations (SPC f)
keymap("n", "<leader>fs", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>fq", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>fQ", ":qa!<CR>", { desc = "Quit all without saving" })
keymap("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Find file" })
keymap("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end, { desc = "Switch buffer" })
keymap("n", "<leader>fo", function()
	local extensions = {
		c = { "h" },
		h = { "c", "cpp", "cc" },
		cpp = { "hpp", "h" },
		hpp = { "cpp", "cc" },
		cc = { "hh", "h" },
		hh = { "cc", "cpp" },
	}
	local name_without_ext = vim.fn.expand("%:t:r")
	local current_ext = vim.fn.expand("%:e")
	local target_exts = extensions[current_ext]

	if target_exts then
		local search_paths = { ".", "../include", "../src", "./include", "./src", "../source", "./source" }
		local candidates = {}

		for _, target_ext in ipairs(target_exts) do
			local target_file = name_without_ext .. "." .. target_ext

			for _, path in ipairs(search_paths) do
				local full_path = vim.fn.expand("%:p:h") .. "/" .. path .. "/" .. target_file
				if vim.fn.filereadable(full_path) == 1 then
					table.insert(candidates, full_path)
				end
			end
		end

		if #candidates == 1 then
			vim.cmd("edit " .. candidates[1])
		elseif #candidates > 1 then
			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			pickers.new({}, {
				prompt_title = "Select Alternate File",
				finder = finders.new_table({
					results = candidates,
					entry_maker = function(entry)
						return {
							value = entry,
							display = vim.fn.fnamemodify(entry, ":~:."),
							ordinal = vim.fn.fnamemodify(entry, ":~:."),
						}
					end,
				}),
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						vim.cmd("edit " .. selection.value)
					end)
					return true
				end,
			}):find()
		else
			local target_file = name_without_ext .. "." .. table.concat(target_exts, "/")
			print("Could not find " .. target_file)
		end
	else
		print("No alternate file type configured for ." .. current_ext)
	end
end, { desc = "Find other file (header/impl)" })

-- Project commands (SPC p)
keymap("n", "<leader>pf", function()
	require("telescope").extensions.projects.projects()
end, { desc = "Switch project" })
keymap("n", "<leader>pa", function()
	require("telescope.builtin").live_grep()
end, { desc = "Search in project" })
keymap("n", "<leader>p!", function()
	vim.cmd("terminal")
	vim.cmd("startinsert")
end, { desc = "Terminal in project root" })

-- Git commands (SPC g)
keymap("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
keymap("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })

-- Local leader LSP commands
keymap("n", "<localleader>s", function()
	require("telescope.builtin").lsp_document_symbols()
end, { desc = "Search symbols in file" })
keymap("n", "<localleader>S", function()
	require("telescope.builtin").lsp_dynamic_workspace_symbols()
end, { desc = "Search symbols in workspace" })
keymap("n", "<localleader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Emacs-style commands (SPC e)
keymap("n", "<leader>eR", ":source $MYVIMRC<CR>", { desc = "Reload Neovim config" })

-- Undo tree (SPC u)
keymap("n", "<leader>ut", ":UndotreeToggle<CR>", { desc = "Toggle undo tree" })

-- Search history (SPC h)
keymap("n", "<leader>h", function()
	require("telescope.builtin").resume()
end, { desc = "Resume last search" })
