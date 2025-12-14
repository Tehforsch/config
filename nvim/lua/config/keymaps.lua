local keymap = vim.keymap.set

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Navigate to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Navigate to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Clear search highlighting
keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlighting" })

-- Better indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Keep search results centered
keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Paste without yanking in visual mode
keymap("x", "p", '"_dP', { desc = "Paste without yanking" })

-- Delete without yanking
keymap({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

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
	local extensions = { c = "h", h = "c", cpp = "hpp", hpp = "cpp", cc = "hh", hh = "cc" }
	local current_file = vim.fn.expand("%:t")
	local name_without_ext = vim.fn.expand("%:t:r")
	local current_ext = vim.fn.expand("%:e")
	local target_ext = extensions[current_ext]

	if target_ext then
		local target_file = name_without_ext .. "." .. target_ext
		local search_paths = { ".", "../include", "../src", "./include", "./src" }

		for _, path in ipairs(search_paths) do
			local full_path = vim.fn.expand("%:p:h") .. "/" .. path .. "/" .. target_file
			if vim.fn.filereadable(full_path) == 1 then
				vim.cmd("edit " .. full_path)
				return
			end
		end
		print("Could not find " .. target_file)
	else
		print("No alternate file type configured for ." .. current_ext)
	end
end, { desc = "Find other file (header/impl)" })

-- Project commands (SPC p)
keymap("n", "<leader>pf", function()
	require("telescope").extensions.project.project()
end, { desc = "Switch project" })
keymap("n", "<leader>pa", function()
	require("telescope.builtin").live_grep()
end, { desc = "Search in project" })
keymap("n", "<leader>p!", function()
	local project_root = vim.fn.getcwd()
	vim.cmd("terminal")
	vim.cmd("startinsert")
end, { desc = "Terminal in project root" })

-- Git commands (SPC g)
keymap("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
keymap("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })

-- LSP/Consult commands (SPC c)
keymap("n", "<leader>cs", function()
	require("telescope.builtin").lsp_document_symbols()
end, { desc = "Search symbols in file" })
keymap("n", "<leader>cS", function()
	require("telescope.builtin").lsp_workspace_symbols()
end, { desc = "Search symbols in workspace" })

-- Emacs-style commands (SPC e)
keymap("n", "<leader>eR", ":source $MYVIMRC<CR>", { desc = "Reload Neovim config" })

-- Undo tree (SPC u)
keymap("n", "<leader>ut", ":UndotreeToggle<CR>", { desc = "Toggle undo tree" })

-- Search history (SPC h)
keymap("n", "<leader>h", function()
	require("telescope.builtin").resume()
end, { desc = "Resume last search" })
