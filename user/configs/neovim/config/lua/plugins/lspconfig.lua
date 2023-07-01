local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local lspconfig = require("lspconfig")

local null_ls = require("null-ls")
local null_ls_formatting = null_ls.builtins.formatting


null_ls.setup({
  sources = {
    null_ls_formatting.prettier,
    null_ls_formatting.nixpkgs_fmt,
  },
})

lspconfig.nixd.setup { capabilities = capabilities }

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
lspconfig.jedi_language_server.setup { capabilities = capabilities }
lspconfig.bashls.setup { capabilities = capabilities }

lspconfig.cssls.setup {
  capabilities = capabilities,
  cmd = { "css-languageserver", "--stdio" },
  settings = {
    css = { validate = false },
  }
}
