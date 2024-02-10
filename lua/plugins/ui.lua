return {
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function ()
  --     require("tokyonight").setup({
  --       style = "night",
  --     })
  --     vim.cmd.colorscheme("tokyonight")
  --   end
  -- },

  {
    -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({
        transparent = true,
        style = "darker",
      })
      -- vim.cmd.colorscheme("onedark")
    end,
  },

  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   config = function()
  --     require("rose-pine").setup({
  --       variant = "moon",
  --       styles = {
  --         italic = false
  --       },
  --     })
  --     vim.cmd("colorscheme rose-pine")
  --     local p = require("rose-pine.palette")
  --
  --     vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg=p.love })
  --   end,
  -- },

  {
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
    -- Use lualine as statusline
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
    -- Use fidget for notifications
    "j-hui/fidget.nvim",
    config = true,
  },

  {
    "folke/which-key.nvim",
    config = true,
  },
}
