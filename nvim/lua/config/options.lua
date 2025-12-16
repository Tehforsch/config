vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = false
vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.wrapscan = false

vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.clipboard = "unnamedplus"

vim.opt.undofile = true
vim.opt.backup = false
vim.opt.swapfile = false

vim.opt.updatetime = 250
vim.opt.timeoutlen = 10000 -- I dont need this timeout tbh

vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.showmode = false
vim.opt.cmdheight = 1

vim.opt.winbar = "%{%v:lua.require('config.winbar').winbar()%}"
vim.opt.laststatus = 0
vim.opt.ruler = false
