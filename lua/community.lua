-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.editing-support.mini-splitjoin" },
  { import = "astrocommunity.editing-support.telescope-undo-nvim" },
  { import = "astrocommunity.editing-support.nvim-devdocs" },
  { import = "astrocommunity.git.octo-nvim" },
  { import = "astrocommunity.git.openingh-nvim" },
  { import = "astrocommunity.motion.harpoon" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.swift" },
  { import = "astrocommunity.lsp.actions-preview-nvim" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.search.nvim-spectre" },
  { import = "astrocommunity.scrolling.mini-animate" },
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.color.nvim-highlight-colors" },
  { import = "astrocommunity.recipes.telescope-lsp-mappings" },
  { import = "astrocommunity.utility.telescope-live-grep-args-nvim" },
  { import = "astrocommunity.fuzzy-finder.telescope-zoxide" },
  { import = "astrocommunity.terminal-integration.toggleterm-manager-nvim" },
  -- { import = "astrocommunity.workflow.hardtime-nvim" },
  -- { import = "astrocommunity.code-runner.overseer-nvim" },

  { import = "astrocommunity.colorscheme.catppuccin" },
  {
    "catppuccin",
    ---@type CatppuccinOptions
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dap = true,
        dap_ui = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = true,
        markdown = true,
        mason = true,
        native_lsp = { enabled = true },
        neotree = true,
        neotest = true,
        notify = true,
        octo = true,
        semantic_tokens = true,
        symbols_outline = true,
        telescope = true,
        treesitter = true,
        ts_rainbow = false,
        ufo = true,
        which_key = true,
        window_picker = true,
      },
      dim_inactive = {
        enabled = true,
      },
      custom_highlights = function(colors)
        return {
          -- revert https://github.com/catppuccin/nvim/pull/768
          -- I feel like overlay2 is far too bright for a comment
          Comment = { fg = colors.overlay0 },
        }
      end,
    },
  },

  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      dim_inactive = true,
    },
  },

  { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = "100",
    },
  },

  -- {
  --   "rebelot/kanagawa.nvim",
  --   opts = {
  --     dimInactive = true,
  --   },
  -- },

  -- { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
  -- { import = "astrocommunity.color.tint-nvim"},
  -- { import = "astrocommunity.completion.copilot-lua-cmp" },
  -- { import = "astrocommunity.scrolling.satellite-nvim" },
}
