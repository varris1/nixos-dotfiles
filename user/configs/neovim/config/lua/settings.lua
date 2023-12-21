vim.g.mapleader = " "

-- 4 space tabs
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.smartindent = true

vim.o.background = "dark"
vim.o.clipboard = "unnamedplus"
-- vim.o.mouse = ""
vim.o.termguicolors = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrap = false
vim.o.scrolloff = 8

vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"
vim.o.undofile = true

vim.o.scrolloff = 8

vim.wo.number = true
vim.wo.relativenumber = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = "nix",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})
