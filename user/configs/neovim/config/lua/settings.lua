vim.g.mapleader = " "

-- 4 space tabs
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true

vim.o.background = "dark"
vim.o.clipboard = "unnamedplus"
-- vim.o.mouse = ""
vim.o.termguicolors = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.lazyredraw = true
vim.o.wrap = false
vim.o.scrolloff = 8

vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"
vim.o.undofile = true

vim.o.scrolloff = 8

vim.wo.number = true
vim.wo.relativenumber = true
