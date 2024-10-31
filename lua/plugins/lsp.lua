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
          "ruby_lsp",
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

          ["ruby_lsp"] = function()
            require("lspconfig").ruby_lsp.setup({
              capabilities = capabilities,
              cmd = { os.getenv("HOME") .. "/.asdf/shims/ruby-lsp" },
              on_attach = function(client, bufnr)
                client.commands["rubyLsp.runTest"] = function(command)
                  local args = command.arguments
                  local test_command = args[3]
                  vim.cmd("redraw")
                  vim.cmd("!" .. test_command)
                end

                client.commands["rubyLsp.runTestInTerminal"] = function(command)
                  local args = command.arguments
                  local test_command = args[3]
                  vim.g.VimuxOrientation = "h"
                  vim.g.VimuxHeight = "50"
                  vim.fn.VimuxRunCommand(test_command)
                  vim.fn.system("tmux select-pane -t 1")
                end

                client.commands["rubyLsp.debugTest"] = function(command)
                  local args = command.arguments
                  local test_command = args[3]

                  -- Split the command into arguments
                  local cmd_args = {}
                  for arg in test_command:gmatch("%S+") do
                    table.insert(cmd_args, arg)
                  end

                  -- Extract the command and the rest of the arguments
                  table.remove(cmd_args, 1) -- ignore the first argument since it runs ruby
                  local cmd = table.remove(cmd_args, 1)

                  -- Start the debug session
                  require("dap").run({
                    type = "ruby",
                    name = "debug test",
                    request = "attach",
                    localfs = true,
                    command = cmd,
                    script = cmd_args,
                  })
                end

                if client.server_capabilities.codeLensProvider then
                  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                    buffer = bufnr,
                    callback = function()
                      vim.lsp.codelens.refresh({ bufnr = bufnr })
                    end,
                  })
                end
              end,
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
