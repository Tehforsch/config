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

-- File operations
keymap("n", "<leader>fs", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>fq", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>fQ", ":qa!<CR>", { desc = "Quit all without saving" })

-- Emacs-style reload
keymap("n", "<leader>eR", ":source $MYVIMRC<CR>", { desc = "Reload Neovim config" })
