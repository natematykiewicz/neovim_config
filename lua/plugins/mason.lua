-- Customize Mason

-- TODO:
-- Get sorbet, ruby lsp, erb lint, to work via Neovim

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install any other package
        "tree-sitter-cli",

        "dockerfile-language-server",
        "html-lsp",
        "lua-language-server",
        "ruby-lsp",
        -- "sorbet",
        "stylua",
        "tailwindcss-language-server",
      },
    },
  },
}
