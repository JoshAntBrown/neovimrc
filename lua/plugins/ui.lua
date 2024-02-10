return {
  {
    -- Catppuccin Frappe theme
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "frappe",
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    -- Status line UI
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        theme = "catppuccin",
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
    -- Keybindings UI
    "folke/which-key.nvim",
    config = true,
  },
}
