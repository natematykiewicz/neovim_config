-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("ruby", { "rails" })
      luasnip.filetype_extend("typescript", { "typescript" })
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    event = "BufEnter *.md",
    config = function() vim.fn["mkdp#util#install"]() end,
  },

  -- { "mihyaeru21/nvim-lspconfig-bundler", dependencies = "neovim/nvim-lspconfig" },
  { "tpope/vim-rails", ft = { "ruby", "eruby" } },
  { "tpope/vim-bundler", ft = { "ruby", "eruby" } },
  { "tpope/vim-surround", lazy = false },
  { "kchmck/vim-coffee-script", ft = { "coffee" } },

  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },

  -- {
  --   "ThePrimeagen/git-worktree.nvim",
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  --   opts = function()
  --     require("telescope").setup {
  --       defaults = {
  --         path_display = { "smart" },
  --       },
  --     }
  --     require("telescope").load_extension "git_worktree"
  --   end,
  --   keys = {
  --     {
  --       "<leader>gW",
  --       function() require("telescope").extensions.git_worktree.create_git_worktree() end,
  --       desc = "Create Worktree",
  --     },
  --     {
  --       "<leader>gw",
  --       function() require("telescope").extensions.git_worktree.git_worktrees() end,
  --       desc = "View Worktrees",
  --     },
  --   },
  -- },

  -- { "mistricky/codesnap.nvim", build = "make" },

  { "mattn/emmet-vim" },
  { "dmmulroy/ts-error-translator.nvim" },

  {
    "psliwka/vim-dirtytalk",
    build = ":DirtytalkUpdate",
    config = function() vim.opt.spelllang = { "en", "programming" } end,
    event = "User AstroFile",
  },

  { "gpanders/editorconfig.nvim" },

  {
    "FabijanZulj/blame.nvim",
    event = "User AstroGitFile",
    config = function()
      require("astrocore").set_mappings {
        n = {
          ["<leader>gB"] = { "<cmd>ToggleBlame window<cr>", desc = "View Git blame for full file" },
        },
      }
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = { "suketa/nvim-dap-ruby", config = true },
  },

  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
}
