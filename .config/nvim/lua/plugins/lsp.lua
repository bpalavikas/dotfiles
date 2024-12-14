return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },

  { 'williamboman/mason.nvim', config = true },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },

      -- styling
      { 'onsails/lspkind.nvim' },
      { 'nvim-tree/nvim-web-devicons' },

      -- other sources
      { 'hrsh7th/cmp-emoji' },
      { 'hrsh7th/cmp-cmdline' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-buffer' },
      { 'Saecki/crates.nvim' },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      local cmp = require('cmp')

      local sources = {
        { name = 'neorg' },
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'crates' },
        { name = 'emoji' },
        { name = 'path' },
        { name = 'buffer' },
      }

      local formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        format = require('lspkind').cmp_format({
          mode = 'symbol',
        }),
      }

      local sign = function(opts)
        vim.fn.sign_define(opts.name, {
          texthl = opts.name,
          text = opts.text,
          numhl = '',
        })
      end

      sign({ name = 'DiagnosticSignError', text = '✘' })
      sign({ name = 'DiagnosticSignWarn', text = '▲' })
      sign({ name = 'DiagnosticSignHint', text = '⚑' })
      sign({ name = 'DiagnosticSignInfo', text = '' })

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = true,
        underline = true,
        serverity_sort = true,
      })

      -- load custom snippets
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        formatting = formatting,

        sources = sources,
        mapping = cmp.mapping.preset.insert({
                    -- Select the [n]ext item
          ['<C-j>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-k>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          
          -- use C-n to trigger completion too
          ['<C-n>'] = function(_)
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end,
        }),

        experimental = {
          ghost_text = true,
        },
      })


      require('cmp').setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

      require('cmp').setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' },
            },
          },
        }),
      })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'williamboman/mason-lspconfig.nvim' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'folke/neodev.nvim' },
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
        vim.keymap.set('n', 'gn', vim.lsp.buf.rename, { desc = 'Rename Symbol', buffer = true })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Goto Definition', buffer = true })
        --vim.lsp.inlay_hint.enable(0, true)
      end)

      require('mason-lspconfig').setup({
        ensure_installed = {
          'rust_analyzer',
          'lua_ls',
        },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
        },
      })

      require('neodev').setup({})
    end,
  },
}
