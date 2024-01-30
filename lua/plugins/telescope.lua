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
      require("telescope").setup()
      pcall(require("telescope").load_extension, "fzf")

      vim.keymap.set("n", "<leader>pf", require("telescope.builtin").find_files, { desc = "[pf] Find project files"})
      vim.keymap.set("n", "<leader>ps", require("telescope.builtin").git_status, { desc = "[ps] Find project git status" })
      vim.keymap.set("n", "<leader>pg", require("telescope.builtin").live_grep, { desc = "[pg] Find project grep" })
      vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
      vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>/", function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = "[/] Fuzzily search in current buffer" })
    end
  }

}
