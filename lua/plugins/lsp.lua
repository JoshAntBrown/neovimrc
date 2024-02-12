return {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
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
          "ruby_ls",
          "html",
          "emmet_language_server",
          "terraformls",
          "tsserver",
        },

        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,

          ["ruby_ls"] = function()
            -- textDocument/diagnostic support until 0.10.0 is released
            _timers = {}
            local function setup_diagnostics(client, buffer)
              if require("vim.lsp.diagnostic")._enable then
                return
              end

              local diagnostic_handler = function()
                local params = vim.lsp.util.make_text_document_params(buffer)
                client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
                  if err then
                    local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
                    vim.lsp.log.error(err_msg)
                  end
                  local diagnostic_items = {}
                  if result then
                    diagnostic_items = result.items
                  end
                  vim.lsp.diagnostic.on_publish_diagnostics(
                    nil,
                    vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
                    { client_id = client.id }
                  )
                end)
              end

              diagnostic_handler() -- to request diagnostics on buffer when first attaching

              vim.api.nvim_buf_attach(buffer, false, {
                on_lines = function()
                  if _timers[buffer] then
                    vim.fn.timer_stop(_timers[buffer])
                  end
                  _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
                end,
                on_detach = function()
                  if _timers[buffer] then
                    vim.fn.timer_stop(_timers[buffer])
                  end
                end,
              })
            end

            require("lspconfig").ruby_ls.setup({
              capabilities = capabilities,
              cmd = { os.getenv("HOME") .. "/.asdf/shims/ruby-lsp" },
              on_attach = function(client, buffer)
                setup_diagnostics(client, buffer)
              end,
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
          null_ls.builtins.diagnostics.erb_lint,
        },
      })
    end,
  },
}
