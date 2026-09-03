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
    lazy = false,
    priority = 1000,
    config = function()
      -- The light/dark variant is driven by the `theme` script
      -- (~/.local/bin/theme) so Ghostty, tmux and Neovim switch together.
      -- It persists the choice in ~/.local/state/theme/current and calls
      -- SetTheme() over RPC in already-running instances.
      local function saved_variant()
        local f = io.open(vim.fn.expand("~/.local/state/theme/current"), "r")
        if not f then
          return "dawn"
        end
        local v = (f:read("*l") or ""):gsub("%s+", "")
        f:close()
        return v == "moon" and "moon" or "dawn"
      end

      require("rose-pine").setup({
        variant = "auto", -- follow 'background': dawn when light, dark_variant when dark
        dark_variant = "moon",
      })

      function _G.SetTheme(variant)
        vim.o.background = variant == "moon" and "dark" or "light"
        return vim.o.background
      end

      _G.SetTheme(saved_variant())
      vim.cmd.colorscheme("rose-pine")

      -- :Theme [dawn|moon|toggle] runs the script so every app switches.
      vim.api.nvim_create_user_command("Theme", function(cmd)
        vim.system({ "theme", cmd.args }, { text = true }, function(res)
          vim.schedule(function()
            vim.notify(vim.trim(res.stdout .. res.stderr), res.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR)
          end)
        end)
      end, {
        nargs = "?",
        complete = function() return { "dawn", "moon", "toggle" } end,
      })
    end,
  },

  {
    -- Status line UI
    "nvim-lualine/lualine.nvim",
    config = function()
      local opts = {
        options = {
          icons_enabled = false,
          theme = "rose-pine",
          component_separators = "|",
          section_separators = "",
        },
      }
      require("lualine").setup(opts)

      -- rose-pine's lualine theme is built from the active palette, so
      -- rebuild it whenever the colorscheme reloads (e.g. light <-> dark).
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("user_lualine_theme", { clear = true }),
        callback = function()
          package.loaded["lualine.themes.rose-pine"] = nil
          require("lualine").setup(opts)
        end,
      })
    end,
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
  },
}
