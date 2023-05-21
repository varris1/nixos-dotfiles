vim.g.mapleader = ","

-- 4 space tabs
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true

vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.lazyredraw = true
vim.o.timeoutlen = 100

vim.wo.number = true
vim.wo.relativenumber = true

require("catppuccin").setup({
  flavour = "macchiato",
  transparent_background = true,
})
vim.cmd.colorscheme "catppuccin"

require("lualine").setup({
  options = {
    theme = "catppuccin",
  }
})

require("dressing").setup()

require("bufferline").setup({
  highlights = require("catppuccin.groups.integrations.bufferline").get(),
  options = {
    show_tab_indicators = true,
    -- separator_style = { "", "" },
    indicator = { style = "icon", icon = "▎" },
    color_icons = true,
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        text_align = "center",
        separator = true,
      },
    },
  },
})

require("colorizer").setup()
require("nvim-autopairs").setup()
require("Comment").setup()

require("neo-tree").setup({
  default_component_configs = {
    icon = {
      folder_empty = "󰜌",
      folder_empty_open = "󰜌",
    },
    git_status = {
      symbols = {
        renamed   = "󰁕",
        unstaged  = "󰄱",
      },
    },
  },
  document_symbols = {
    kinds = {
      File = { icon = "󰈙", hl = "Tag" },
      Namespace = { icon = "󰌗", hl = "Include" },
      Package = { icon = "󰏖", hl = "Label" },
      Class = { icon = "󰌗", hl = "Include" },
      Property = { icon = "󰆧", hl = "@property" },
      Enum = { icon = "󰒻", hl = "@number" },
      Function = { icon = "󰊕", hl = "Function" },
      String = { icon = "󰀬", hl = "String" },
      Number = { icon = "󰎠", hl = "Number" },
      Array = { icon = "󰅪", hl = "Type" },
      Object = { icon = "󰅩", hl = "Type" },
      Key = { icon = "󰌋", hl = "" },
      Struct = { icon = "󰌗", hl = "Type" },
      Operator = { icon = "󰆕", hl = "Operator" },
      TypeParameter = { icon = "󰊄", hl = "Type" },
      StaticMethod = { icon = '󰠄 ', hl = 'Function' },
    }
  },
})

require("nvim-treesitter.configs").setup({
  highlight = { enable = true, },
})

require("which-key").setup()

local ts_builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', ts_builtin.find_files, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fg', ts_builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set('n', '<leader>fb', ts_builtin.buffers, { desc = "List Buffers" })
vim.keymap.set('n', '<leader>fh', ts_builtin.help_tags, { desc = "Help Tags" })
vim.keymap.set('n', '<leader>fc', ts_builtin.git_files, { desc = "Find Files (Git)" })

require("telescope").load_extension("fzf")

require('nvim-surround').setup()

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require("lspconfig")
lspconfig.rnix.setup {
  capabilities = capabilities
}
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
lspconfig.clangd.setup {}

require("luasnip.loaders.from_vscode").lazy_load()

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")

local lspkind = require("lspkind")
local luasnip = require("luasnip")
cmp.setup({
  preselect = cmp.PreselectMode.None,
  formatting = {
    format = lspkind.cmp_format ({
      mode = "symbol",

      symbol_map = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "",
        Variable = "󰀫",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = ""
      },
    }),
  },

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  sources = cmp.config.sources ({
    { name = "buffer" },
    { name = "path" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }),

  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
        -- they way you will only jump inside the snippet region
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
'confirm_done',
cmp_autopairs.on_confirm_done()
)

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" },
  })
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "buffer" },
  })
})

-- keymaps 
vim.keymap.set("n", "<C-n>", "<cmd>NeoTreeFocusToggle<CR>")

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
