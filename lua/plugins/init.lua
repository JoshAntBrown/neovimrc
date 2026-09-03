return {
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    },
  },

  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = true,
  },

  {
    "laytan/cloak.nvim",
    config = true,
  },

  "theprimeagen/vim-be-good",

  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        backdrop = 1,
        height = 0.8,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          -- colorcolumn = "0",
        },
      },
      plugins = {
        options = {
          enabled = true,
          laststatus = 0,
        },
        tmux = {
          enabled = true,
        },
        -- alacritty = {
        --   enabled = true,
        --   font = "14",
        -- },
      },
    },
  },

  {
    "folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.5,
      },
    }
  },

  "preservim/vim-pencil",
}
