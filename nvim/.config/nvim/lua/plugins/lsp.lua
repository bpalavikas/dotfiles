return {
  {
    "neovim/nvim-lspconfig",

    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
      { "williamboman/mason.nvim", config = true },
      { "williamboman/mason-lspconfig.nvim" },
      { "saghen/blink.cmp" },
    },

    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "clangd",
          "rust_analyzer",
          "bashls",
          "gopls",
          "basedpyright",
          "ts_ls",
          "vimls",
          "marksman",
          "yamlls",
          "jsonls",
          "html",
          "cssls",
          "dockerls",
        },
      })

      local servers = {
        lua_ls = {
          capabilities = capabilities,

          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },

              diagnostics = {
                globals = { "vim" },
              },

              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },

              telemetry = {
                enable = false,
              },
            },
          },
        },

        clangd = {
          capabilities = capabilities,

          root_markers = {
            "compile_commands.json",
            "compile_flags.txt",
            ".clangd",
            ".git",
          },
        },

        ts_ls = {
          capabilities = capabilities,

          root_markers = {
            "package.json",
            "tsconfig.json",
            "jsconfig.json",
            ".git",
          },

          single_file_support = false,
        },

        basedpyright = { capabilities = capabilities },
        bashls = { capabilities = capabilities },
        gopls = { capabilities = capabilities },
        rust_analyzer = { capabilities = capabilities },
        vimls = { capabilities = capabilities },
        marksman = { capabilities = capabilities },
        yamlls = { capabilities = capabilities },
        jsonls = { capabilities = capabilities },
        html = { capabilities = capabilities },
        cssls = { capabilities = capabilities },
        dockerls = { capabilities = capabilities },
      }

      for server, config in pairs(servers) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,

        float = {
          border = "rounded",
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = {
            buffer = event.buf,
            silent = true,
          }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, opts)

          vim.keymap.set("n", "<leader>lk", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })
    end,
  },
}
