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

      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
