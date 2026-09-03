return {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "preservim/vimux",
    },

    config = function()
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      -- Neovim 0.11+ native LSP config (nvim-lspconfig now only ships the
      -- per-server configs under lsp/; mason-lspconfig v2 enables installed
      -- servers automatically via vim.lsp.enable()).
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("tailwindcss", {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                [[class= '([^']*)]],
                [[class: '([^']*)]],
                [[class= "([^"]*)]],
                [[class: "([^"]*)]],
                '~H""".*class="([^"]*)".*"""',
                '~F""".*class="([^"]*)".*"""',
              },
            },
          },
        },
      })

      vim.lsp.config("ruby_lsp", {
        init_options = {
          addonSettings = {
            ["Ruby LSP Rails"] = {
              enablePendingMigrationsPrompt = false,
            },
          },
        },
      })
      -- ruby-lsp is installed via bundler, not mason, so enable it explicitly.
      vim.lsp.enable("ruby_lsp")

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "html",
          "emmet_language_server",
          "tailwindcss",
          "terraformls",
          "ts_ls",
          "stimulus_ls",
          "stylelint_lsp",
        },
        -- mason-lspconfig v2 auto-enables every installed Mason package that
        -- has an lspconfig entry. stylua is only used via none-ls for
        -- formatting, so don't also run it as a language server.
        automatic_enable = {
          exclude = { "stylua" },
        },
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.erb_format,
          null_ls.builtins.diagnostics.erb_lint.with({
            ignore_stderr = true,
          }),
        },
      })
    end,
  },
}
