-- nvim-treesitter `main` branch. The old `master` branch (and its
-- `require("nvim-treesitter.configs")` API) is archived and breaks on
-- Neovim 0.12 (e.g. markdown injections error with "attempt to call
-- method 'range'").
local ensure_installed = {
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
  "markdown_inline",
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
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",

  config = function()
    local ts = require("nvim-treesitter")
    ts.setup({})

    -- Install any missing parsers in the background (needs `tree-sitter` CLI + a C compiler).
    local installed = {}
    for _, lang in ipairs(ts.get_installed("parsers")) do
      installed[lang] = true
    end
    local missing = vim.tbl_filter(function(lang)
      return not installed[lang]
    end, ensure_installed)
    if #missing > 0 then
      ts.install(missing)
    end

    -- Highlighting + indentation are enabled per buffer now instead of via a
    -- `highlight = { enable = true }` option.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end
        -- `language.add` returns false (rather than erroring) when no parser
        -- is installed for the language, so check both the pcall and result.
        local ok, has_parser = pcall(vim.treesitter.language.add, lang)
        if not ok or not has_parser then
          return
        end
        if not pcall(vim.treesitter.start, args.buf, lang) then
          return
        end

        -- Ruby still depends on vim's regex highlighting/indent (see old
        -- `additional_vim_regex_highlighting` / `indent.disable`).
        if args.match == "ruby" then
          vim.bo[args.buf].syntax = "on"
        else
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
