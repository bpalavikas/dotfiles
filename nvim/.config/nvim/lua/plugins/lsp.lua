return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },

    -- Explicit load order: nvim-cmp BEFORE cmp-nvim-lsp
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      { "williamboman/mason-lspconfig.nvim" }, -- unpinned, recent supports ts_ls
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      -- NOTE: deliberately NOT using cmp-nvim-lsp for now (it caused the bufnr error)
    },

    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      -- Base capabilities (no cmp-nvim-lsp while we stabilize)
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "clangd",
          "lua_ls",
          "rust_analyzer",
          "bashls",
          "gopls",
          "texlab",
          "basedpyright",
        },
        automatic_enable = false,
        handlers = {
          -- default handler
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,

          -- Lua
          lua_ls = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = { version = "LuaJIT" },
                  diagnostics = { globals = { "vim" } },
                  workspace = { checkThirdParty = false },
                  telemetry = { enable = false },
                },
              },
            })
          end,

          -- Python
          basedpyright = function()
            lspconfig.basedpyright.setup({
              capabilities = capabilities,
            })
          end,

          -- C/C++
          clangd = function()
            lspconfig.clangd.setup({
              capabilities = capabilities,
              root_dir = util.root_pattern(
                "compile_commands.json",
                "compile_flags.txt",
                ".clangd",
                ".git"
              ),
            })
          end,

          -- TypeScript / JavaScript
          ts_ls = function()
            lspconfig.ts_ls.setup({
              capabilities = capabilities,
              root_dir = util.root_pattern("package.json", "tsconfig.json", ".git"),
              single_file_support = false,
              init_options = { hostInfo = "neovim" },
            })
          end,
        },
      })

      -- Diagnostics
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded" },
      })

      -- Rounded hover
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

      -- LspAttach: keymaps + document highlight (scoped & capability-checked)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(e)
          local client = vim.lsp.get_client_by_id(e.data.client_id)

          -- Keymaps
          local opts = { buffer = e.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gh", vim.lsp.buf.document_highlight, opts)
          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>lk", vim.diagnostic.open_float, opts)

          -- Document highlight if supported
          if client
            and client.server_capabilities
            and client.server_capabilities.documentHighlightProvider
          then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = e.buf,
              callback = function()
                pcall(vim.lsp.buf.document_highlight)
              end,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = e.buf,
              callback = function()
                pcall(vim.lsp.buf.clear_references)
              end,
            })
          end
        end,
      })

      -- nvim-cmp (buffer/path only while we avoid cmp-nvim-lsp)
      local cmp = require("cmp")
      local ok_snip, luasnip = pcall(require, "luasnip")

      cmp.setup({
        completion = { autocomplete = false }, -- manual trigger
        enabled = function()
          local bt = vim.bo.buftype
          return bt ~= "prompt" and bt ~= "nofile"
        end,
        snippet = ok_snip and {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        } or nil,
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete(),   -- manual popup
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Built-in LSP omni-completion on <C-Space> (for LSP items without cmp-nvim-lsp)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(e)
          vim.bo[e.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        end,
      })
      vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { silent = true })
    end,
  },
}

