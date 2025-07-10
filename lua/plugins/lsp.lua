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

        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,

          ["tailwindcss"] = function()
            local lspconfig = require("lspconfig")

            lspconfig.tailwindcss.setup({
              capabilities = capabilities,
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
          end,

          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                },
              },
            })
          end,
        },
      })

      require("lspconfig").ruby_lsp.setup({
        capabilities = capabilities,
        init_options = {
          addonSettings = {
            ["Ruby LSP Rails"] = {
              enablePendingMigrationsPrompt = false,
            },
          },
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
