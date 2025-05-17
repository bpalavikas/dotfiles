-- lsp_full_config.lua - Universal LSP setup with diagnostics, completion, and Typst preview

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      { 'williamboman/mason-lspconfig.nvim', version = '1.29.0' },
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
      { 'chomosuke/typst-preview.nvim', lazy = false },
    },
    config = function()
      local lspconfig = require('lspconfig')
      local cmp_nvim_lsp = require('cmp_nvim_lsp')

      require('mason').setup()

      require('mason-lspconfig').setup({
        ensure_installed = {
          'clangd', 'lua_ls', 'pyright', 'rust_analyzer',
          'bashls', 'gopls', 'texlab',
        },
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = cmp_nvim_lsp.default_capabilities(),
            })
          end,
          lua_ls = function()
            lspconfig.lua_ls.setup({
              capabilities = cmp_nvim_lsp.default_capabilities(),
              settings = {
                Lua = {
                  runtime = { version = 'LuaJIT' },
                  diagnostics = { globals = { 'vim' } },
                  workspace = { checkThirdParty = false },
                  telemetry = { enable = false },
                }
              }
            })
          end,
          tinymist = function()
            lspconfig.tinymist.setup({
              capabilities = cmp_nvim_lsp.default_capabilities(),
              settings = {
                formatterMode = 'typstyle',
                exportPdf = 'onSave',
                semanticTokens = 'disable',
              },
              root_dir = function(fname)
                return vim.fn.getcwd()
              end,
            })
          end
        }
      })

      -- Diagnostics and border config
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded' },
      })

      -- Hover handler with rounded border
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = "rounded" }
      )

      -- LspAttach mappings
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(e)
          local opts = { buffer = e.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gh", vim.lsp.buf.document_highlight, opts)
          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>lk", vim.diagnostic.open_float, opts)
        end,
      })
    end,
  },
}
