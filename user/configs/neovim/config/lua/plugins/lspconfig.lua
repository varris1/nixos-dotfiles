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
lspconfig.jedi_language_server.setup { capabilities = capabilities }
lspconfig.bashls.setup { capabilities = capabilities }

lspconfig.cssls.setup {
  capabilities = capabilities,
  cmd = { "css-languageserver", "--stdio" },
  settings = {
    css = { validate = false },
  }
}
