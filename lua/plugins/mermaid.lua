return {
  "kevalin/mermaid.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("mermaid").setup {
      lint = {
        enabled = true, -- Enable usage of mmdc for checking errors
      },
      preview = {
        renderer = "beautiful-mermaid", -- "mermaid.js" (default) or "beautiful-mermaid"
        theme = "catppuccin-mocha", -- Theme name (renderer-specific)
      },
    }
  end,
}
