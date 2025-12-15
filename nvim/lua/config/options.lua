-- General settings
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.termguicolors = true

-- Tabs and indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Appearance
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Undo and backup
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.swapfile = false

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 10000

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- UI elements (minimal UI)
vim.opt.showmode = false
vim.opt.cmdheight = 1
