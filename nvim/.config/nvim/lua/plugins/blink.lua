return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",

    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },

      "rafamadriz/friendly-snippets",
    },

    opts = {
      keymap = {
        preset = "none",

        ["<C-Space>"] = { "show", "hide" },
        ["<CR>"] = { "accept", "fallback" },

        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },

        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },

      completion = {
        menu = {
          auto_show = false,
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
        },
      },

      sources = {
        default = {
          "lsp",
          "path",
          "buffer",
          "snippets",
        },
      },

      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
      },

      fuzzy = {
        implementation = "prefer_rust",

        prebuilt_binaries = {
          download = true,
        },
      },
    },
  },
}
