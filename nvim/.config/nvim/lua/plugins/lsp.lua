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
      local cmp = require('cmp')
      local cmp_nvim_lsp = require('cmp_nvim_lsp')

      local capabilities = cmp_nvim_lsp.default_capabilities()

      require('mason').setup()

      require('mason-lspconfig').setup({
        ensure_installed = {
          'clangd', 'lua_ls', 'pyright', 'rust_analyzer',
          'bashls', 'gopls', 'texlab',
        },
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,

          lua_ls = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
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

          clangd = function()
            lspconfig.clangd.setup({
              capabilities = capabilities,
              root_dir = function()
                return vim.fn.getcwd()
              end,
            })
          end,

          tinymist = function()
            lspconfig.tinymist.setup({
              capabilities = capabilities,
              root_dir = function()
                return vim.fn.getcwd()
              end,
              settings = {
                formatterMode = 'typstyle',
                exportPdf = 'onSave',
                semanticTokens = 'disable',
              },
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

      -- Cmp setup with proper completion mapping
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },
}
