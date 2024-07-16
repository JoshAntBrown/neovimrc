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
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
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
        height = 0.8,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          colorcolumn = "0",
        },
      },
      plugins = {
        tmux = {
          enabled = true,
        },
        alacritty = {
          enabled = true,
          font = "14",
        },
      },
    },
  },

  {
    "folke/twilight.nvim",
    config = true,
  },

  "preservim/vim-pencil",

  {
    "junegunn/goyo.vim",
    config = function()
      local goyo_group = vim.api.nvim_create_augroup("GoyoGroup", { clear = true })

      vim.api.nvim_create_autocmd("User", {
        group = goyo_group,
        pattern = "GoyoEnter",
        callback = function()
          -- Your logic to disable lualine goes here
          vim.g.lualine_active = false
          require("lualine").hide()
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        group = goyo_group,
        pattern = "GoyoLeave",
        callback = function()
          -- Your logic to enable lualine goes here
          vim.g.lualine_active = true
          require("lualine").hide({ unhide = true })
        end,
      })
    end,
  },
}
