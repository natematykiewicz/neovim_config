-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-ts-autotag", "RRethy/nvim-treesitter-endwise" },
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.auto_install = true
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
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
    })

    opts.rainbow = {
      enable = false,
    }

    opts.endwise = {
      enable = true,
    }

    opts.indent = {
      enable = true,
    }

    opts.highlight = {
      enable = true,
      disable = { "gitcommit" },
      -- disable = { "ruby", "eruby", "embedded_template" },

      -- Necessary for ``
      -- additional_vim_regex_highlighting = true,
    }
  end,
}
