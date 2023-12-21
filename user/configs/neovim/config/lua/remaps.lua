local map = vim.keymap.set
local telescope_builtin = require("telescope.builtin")
local smart_splits = require("smart-splits")

map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map({ "n", "i" }, "<ESC>", "<cmd>noh<CR><ESC>", { desc = "Escape and clear hlsearch" })
map("n", "<Leader>ff", telescope_builtin.find_files, { desc = "Find Files" })
map("n", "<Leader>fb", telescope_builtin.buffers, { desc = "List Buffers" })
map("n", "<Leader>fh", telescope_builtin.help_tags, { desc = "Help Tags" })
map("n", "<Leader>fp", telescope_builtin.git_files, { desc = "Find Files (Git)" })
map("n", "<Leader>fc", function()
    telescope_builtin.git_files({ cwd = "~/.dotfiles" })
end, { desc = "Edit Dotfiles" })
map("n", "<C-n>", "<cmd>Neotree toggle<CR>", { desc = "Open NeoTree" })
map({ "n", "x" }, "ga", ":EasyAlign", { desc = "Align text" })

-- resizing splits
map("n", "<A-h>", smart_splits.resize_left)
map("n", "<A-j>", smart_splits.resize_down)
map("n", "<A-k>", smart_splits.resize_up)
map("n", "<A-l>", smart_splits.resize_right)

-- moving between splits
map("n", "<C-h>", smart_splits.move_cursor_left)
map("n", "<C-j>", smart_splits.move_cursor_down)
map("n", "<C-k>", smart_splits.move_cursor_up)
map("n", "<C-l>", smart_splits.move_cursor_right)

-- swapping buffers between windows
map("n", "<leader><leader>h", smart_splits.swap_buf_left)
map("n", "<leader><leader>j", smart_splits.swap_buf_down)
map("n", "<leader><leader>k", smart_splits.swap_buf_up)
map("n", "<leader><leader>l", smart_splits.swap_buf_right)

-- null-ls
map("n", "<Leader>lf", vim.lsp.buf.format, { desc = "Format file" })
