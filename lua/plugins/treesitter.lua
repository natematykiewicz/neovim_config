-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-ts-autotag", "RRethy/nvim-treesitter-endwise" },
  opts = {
    auto_install = true,
    ensure_installed = {
      "bash",
      "c",
      "css",
      "csv",
      "dockerfile",
      "embedded_template",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "hlsplaylist",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "ruby",
      "scss",
      "sql",
      "toml",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },

    rainbow = {
      enable = false,
    },

    indent = {
      enable = true,
    },

    highlight = {
      enable = true,
      disable = { "gitcommit" },

      -- Necessary for ``
      -- additional_vim_regex_highlighting = true,
    },
  },
}
