-- Customize Treesitter
-- --------------------
-- Treesitter customizations are handled with AstroCore
-- as nvim-treesitter simply provides a download utility for parsers

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  dependencies = { "nvim-ts-autotag", "RRethy/nvim-treesitter-endwise" },
  opts = {
    treesitter = {
      indent = true, -- enable/disable treesitter based indentation
      auto_install = true, -- enable/disable automatic installation of detected languages
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
        "mermaid",
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

      highlight = {
        enable = true,
        disable = { "gitcommit" },

        -- Necessary for ``
        -- additional_vim_regex_highlighting = true,
      },
    },
  },
}
