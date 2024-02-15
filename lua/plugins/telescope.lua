return {

  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
    },

    config = function()
      require("telescope").setup({
        pickers = {
          find_files = {
            find_command = {'rg', '--files', '--hidden', '-g', '!.git'},
          },
        },
      })
      pcall(require("telescope").load_extension, "fzf")

      local builtin = require('telescope.builtin')

      vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "[pf] Find project files" })
      vim.keymap.set("n", "<leader>ps", builtin.git_status,
        { desc = "[ps] Find project git status" })
      vim.keymap.set("n", "<leader>pg", builtin.live_grep, { desc = "[pg] Find project grep" })
      vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
      vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })

      vim.keymap.set('n', '<leader>pws', function()
        local word = vim.fn.expand("<cword>")
        builtin.grep_string({ search = word })
      end)

      vim.keymap.set('n', '<leader>pWs', function()
        local word = vim.fn.expand("<cWORD>")
        builtin.grep_string({ search = word })
      end)

      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = "[/] Fuzzily search in current buffer" })
    end
  }

}
