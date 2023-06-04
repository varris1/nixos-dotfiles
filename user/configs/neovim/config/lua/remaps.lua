local telescope_builtin = require("telescope.builtin")
local map = vim.keymap.set

map( "n",  "<S-h>",        "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
map( "n",  "<S-l>",        "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map( {"n", "i" }, "<ESC>", "<cmd>noh<CR><ESC>",{ desc = "Escape and clear hlsearch"})
map( "n", "<Leader>ff",    telescope_builtin.find_files,   { desc = "Find Files" })
map( "n", "<Leader>fb",    telescope_builtin.buffers,      { desc = "List Buffers" })
map( "n", "<Leader>fh",    telescope_builtin.help_tags,    { desc = "Help Tags" })
map( "n", "<Leader>fp",    telescope_builtin.git_files,    { desc = "Find Files (Git)" })
map( "n", "<C-n>",         "<cmd>NeoTreeFocusToggle<CR>",  { desc = "Open NeoTree" })
map( {"n", "x"}, "ga",     ":EasyAlign", { desc = "Align text" })
