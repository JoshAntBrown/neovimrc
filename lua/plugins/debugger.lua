return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set("n", "<leader>dc", dap.continue)
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
    vim.keymap.set("n", "<leader>dr", dap.restart)
    vim.keymap.set("n", "<leader>dn", dap.step_over)
    vim.keymap.set("n", "<leader>di", dap.step_into)
    vim.keymap.set("n", "<leader>do", dap.step_out)
    vim.keymap.set("n", "<leader>dl", dap.run_last)
    vim.keymap.set("n", "<leader>du", dapui.toggle)

    dap.adapters.ruby = function(callback, config)
      vim.env.RUBY_DEBUG_OPEN = "true"
      vim.env.RUBY_DEBUG_PORT = "38697"

      callback({
        type = "server",
        host = "127.0.0.1",
        port = "38697",
        executable = {
          command = config.command,
          args = config.script,
        },
      })

      vim.env.RUBY_DEBUG_OPEN = nil
      vim.env.RUBY_DEBUG_PORT = nil
    end

    dap.configurations.ruby = {
      {
        type = "ruby",
        name = "debug current file",
        request = "attach",
        localfs = true,
        command = "ruby",
        script = { "${file}" },
      },
      {
        type = "ruby",
        name = "run current spec file",
        request = "attach",
        localfs = true,
        command = "rspec",
        script = { "${file}" },
      },
    }
  end,
}
