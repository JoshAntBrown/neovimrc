return {
  -- {
  --   -- Catppuccin Frappe theme
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "frappe",
  --       transparent_background = true,
  --     })
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        variant = "moon"
      })
      vim.cmd.colorscheme("rose-pine-moon")
    end,
  },

  {
    -- Status line UI
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        theme = "rose-pine",
        component_separators = "|",
        section_separators = "",
      },
    },
  },

  {
    -- Notification UI
    "j-hui/fidget.nvim",
    config = true,
  },

  {
    -- Diagnostics UI
    "folke/trouble.nvim",
    config = true,
  },

  {
    -- Keybindings UI
    "folke/which-key.nvim",
    config = true,
  },
}
