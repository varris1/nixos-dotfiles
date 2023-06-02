vim.g.mapleader = " "

-- 4 space tabs
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true

vim.o.background = "dark"
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.lazyredraw = true
vim.o.timeoutlen = 100

vim.wo.number = true
vim.wo.relativenumber = true

require("gruvbox").setup({
  transparent_mode = true
})
vim.cmd("colorscheme gruvbox")

require("lualine").setup({
  options = {
    theme = "gruvbox_dark",
  }
})

require("dressing").setup()

require("bufferline").setup({
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

require("colorizer").setup({})
require("nvim-autopairs").setup({})
require("Comment").setup({})

require("neo-tree").setup({
  default_component_configs = {
    icon = {
      folder_empty = "󰜌",
      folder_empty_open = "󰜌",
    },
    git_status = {
      symbols = {
        renamed  = "󰁕",
        unstaged = "󰄱",
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


require("smart-splits").setup()

require("trouble").setup()

local telescope = require("telescope")
telescope.setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {}
    },
  },
})
local telescope_builtin = require("telescope.builtin")
telescope.load_extension("fzf")
telescope.load_extension("ui-select")

require('nvim-surround').setup()

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require("lspconfig")

lspconfig.rnix.setup { capabilities = capabilities }

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
      telemetry = { enable = false },
    },
  },
}

lspconfig.clangd.setup { capabilities = capabilities }
lspconfig.rust_analyzer.setup { capabilities = capabilities }
lspconfig.zls.setup { capabilities = capabilities }

lspconfig.cssls.setup {
  capabilities = capabilities,
  cmd = { "css-languageserver", "--stdio" },
  settings = {
    css = { validate = false },
  }
}

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
    format = lspkind.cmp_format({
      mode = "symbol_text",

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

  sources = cmp.config.sources({
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
      elseif luasnip.expand_or_locally_jumpable() then
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
require("which-key").setup()
require("legendary").setup({
  keymaps = {
    { "<S-h>",      "<cmd>BufferLineCyclePrev<CR>", description = "Prev buffer" },
    { "<S-l>",      "<cmd>BufferLineCycleNext<CR>", description = "Next buffer" },
    { "<ESC>",      "<cmd>noh<CR><ESC>",            description = "Escape and clear hlsearch", mode = { "n", "i" } },
    { "<Leader>ff", telescope_builtin.find_files,   description = "Find Files" },
    { "<Leader>fg", telescope_builtin.live_grep,    description = "Live Grep" },
    { "<Leader>fb", telescope_builtin.buffers,      description = "List Buffers" },
    { "<Leader>fh", telescope_builtin.help_tags,    description = "Help Tags" },
    { "<Leader>fc", telescope_builtin.git_files,    description = "Find Files (Git)" },
    { "<C-n>",      "<cmd>NeoTreeFocusToggle<CR>",  description = "Open NeoTree" },
  },

  extensions = {
    smart_splits = {},
  }
})
