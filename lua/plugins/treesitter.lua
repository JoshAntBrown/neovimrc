return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "embedded_template",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "php",
        "python",
        "ruby",
        "rust",
        "scss",
        "terraform",
        "tsx",
        "typescript",
        "yaml",
        "vim",
        "vimdoc",
      },
      auto_install = false,

      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
    })
  end,
}
