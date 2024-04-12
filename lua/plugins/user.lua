-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        " █████  ███████ ████████ ██████   ██████",
        "██   ██ ██         ██    ██   ██ ██    ██",
        "███████ ███████    ██    ██████  ██    ██",
        "██   ██      ██    ██    ██   ██ ██    ██",
        "██   ██ ███████    ██    ██   ██  ██████",
        " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
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

  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        ruby = { "ruby" },
      }
    end,
    ft = { "ruby" },
  },

  -- { "mihyaeru21/nvim-lspconfig-bundler", dependencies = "neovim/nvim-lspconfig" },
  { "tpope/vim-rails", ft = { "ruby", "eruby" } },
  { "tpope/vim-bundler", ft = { "ruby", "eruby" } },
  { "tpope/vim-surround", lazy = false },
  { "kchmck/vim-coffee-script", ft = { "coffee" } },
  { "mg979/vim-visual-multi", event = "User AstroFile" },

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
    "sindrets/diffview.nvim",
    event = "User AstroGitFile",
    config = function()
      local actions = require "diffview.actions"
      local utils = require "astrocore"

      local prefix = "<leader>D"

      utils.set_mappings {
        n = {
          [prefix] = { name = "Diff View" },
          [prefix .. "<cr>"] = { "<cmd>DiffviewOpen<cr>", desc = "Open DiffView" },
          [prefix .. "h"] = { "<cmd>DiffviewFileHistory %<cr>", desc = "Open DiffView File History" },
          [prefix .. "H"] = { "<cmd>DiffviewFileHistory<cr>", desc = "Open DiffView Branch History" },
        },
      }

      local build_keymaps = function(maps)
        local out = {}
        local i = 1
        for lhs, def in
          pairs(utils.extend_tbl(maps, {
            [prefix .. "q"] = { "<cmd>DiffviewClose<cr>", desc = "Quit Diffview" }, -- Toggle the file panel.
            ["]D"] = { actions.select_next_entry, desc = "Next Difference" }, -- Open the diff for the next file
            ["[D"] = { actions.select_prev_entry, desc = "Previous Difference" }, -- Open the diff for the previous file
            ["[C"] = { actions.prev_conflict, desc = "Next Conflict" }, -- In the merge_tool: jump to the previous conflict
            ["]C"] = { actions.next_conflict, desc = "Previous Conflict" }, -- In the merge_tool: jump to the next conflict
            ["Cl"] = { actions.cycle_layout, desc = "Cycle Diff Layout" }, -- Cycle through available layouts.
            ["Ct"] = { actions.listing_style, desc = "Cycle Tree Style" }, -- Cycle through available layouts.
            ["<leader>e"] = { actions.toggle_files, desc = "Toggle Explorer" }, -- Toggle the file panel.
            ["<leader>o"] = { actions.focus_files, desc = "Focus Explorer" }, -- Bring focus to the file panel
          }))
        do
          local opts
          local rhs = def
          local mode = { "n" }
          if type(def) == "table" then
            if def.mode then mode = def.mode end
            rhs = def[1]
            def[1] = nil
            def.mode = nil
            opts = def
          end
          out[i] = { mode, lhs, rhs, opts }
          i = i + 1
        end
        return out
      end

      require("diffview").setup {
        view = {
          merge_tool = { layout = "diff3_mixed" },
        },
        keymaps = {
          disable_defaults = true,
          view = build_keymaps {
            [prefix .. "o"] = { actions.conflict_choose "ours", desc = "Take Ours" }, -- Choose the OURS version of a conflict
            [prefix .. "t"] = { actions.conflict_choose "theirs", desc = "Take Theirs" }, -- Choose the THEIRS version of a conflict
            [prefix .. "b"] = { actions.conflict_choose "base", desc = "Take Base" }, -- Choose the BASE version of a conflict
            [prefix .. "a"] = { actions.conflict_choose "all", desc = "Take All" }, -- Choose all the versions of a conflict
            [prefix .. "0"] = { actions.conflict_choose "none", desc = "Take None" }, -- Delete the conflict region
          },
          diff3 = build_keymaps {
            [prefix .. "O"] = { actions.diffget "ours", mode = { "n", "x" }, desc = "Get Our Diff" }, -- Obtain the diff hunk from the OURS version of the file
            [prefix .. "T"] = { actions.diffget "theirs", mode = { "n", "x" }, desc = "Get Their Diff" }, -- Obtain the diff hunk from the THEIRS version of the file
          },
          diff4 = build_keymaps {
            [prefix .. "B"] = { actions.diffget "base", mode = { "n", "x" }, desc = "Get Base Diff" }, -- Obtain the diff hunk from the OURS version of the file
            [prefix .. "O"] = { actions.diffget "ours", mode = { "n", "x" }, desc = "Get Our Diff" }, -- Obtain the diff hunk from the OURS version of the file
            [prefix .. "T"] = { actions.diffget "theirs", mode = { "n", "x" }, desc = "Get Their Diff" }, -- Obtain the diff hunk from the THEIRS version of the file
          },
          file_panel = build_keymaps {
            j = actions.next_entry, -- Bring the cursor to the next file entry
            k = actions.prev_entry, -- Bring the cursor to the previous file entry.
            o = actions.select_entry,
            S = actions.stage_all, -- Stage all entries.
            U = actions.unstage_all, -- Unstage all entries.
            X = actions.restore_entry, -- Restore entry to the state on the left side.
            L = actions.open_commit_log, -- Open the commit log panel.
            Cf = { actions.toggle_flatten_dirs, desc = "Flatten" }, -- Flatten empty subdirectories in tree listing style.
            R = actions.refresh_files, -- Update stats and entries in the file list.
            ["-"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
            ["<down>"] = actions.next_entry,
            ["<up>"] = actions.prev_entry,
            ["<cr>"] = actions.select_entry, -- Open the diff for the selected entry.
            ["<2-LeftMouse>"] = actions.select_entry,
            ["<c-b>"] = actions.scroll_view(-0.25), -- Scroll the view up
            ["<c-f>"] = actions.scroll_view(0.25), -- Scroll the view down
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
          },
          file_history_panel = build_keymaps {
            j = actions.next_entry,
            k = actions.prev_entry,
            o = actions.select_entry,
            y = actions.copy_hash, -- Copy the commit hash of the entry under the cursor
            L = actions.open_commit_log,
            zR = { actions.open_all_folds, desc = "Open all folds" },
            zM = { actions.close_all_folds, desc = "Close all folds" },
            ["?"] = { actions.options, desc = "Options" }, -- Open the option panel
            ["<down>"] = actions.next_entry,
            ["<up>"] = actions.prev_entry,
            ["<cr>"] = actions.select_entry,
            ["<2-LeftMouse>"] = actions.select_entry,
            ["<C-A-d>"] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
            ["<c-b>"] = actions.scroll_view(-0.25),
            ["<c-f>"] = actions.scroll_view(0.25),
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
          },
          option_panel = {
            q = actions.close,
            o = actions.select_entry,
            ["<cr>"] = actions.select_entry,
            ["<2-LeftMouse"] = actions.select_entry,
          },
        },
      }
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = { "suketa/nvim-dap-ruby", config = true },
  },

  { -- override nvim-cmp plugin
    "hrsh7th/nvim-cmp",
    -- override the options table that is used in the `require("cmp").setup()` call
    opts = function(_, opts)
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      local cmp = require "cmp"
      -- modify the sources part of the options table
      opts.sources = cmp.config.sources {
        -- Default:
        -- { name = "nvim_lsp", priority = 1000 },
        -- { name = "luasnip", priority = 750 },
        -- { name = "buffer", priority = 500 },
        -- { name = "path", priority = 250 },
        { name = "buffer", priority = 1000 },
        { name = "nvim_lsp", priority = 750 },
        { name = "luasnip", priority = 500 },
        { name = "path", priority = 250 },
      }

      -- return the new table to be used
      return opts
    end,
  },

  {
    "nvim-neotest/neotest",
    ft = { "ruby" },
    dependencies = {
      "olimorris/neotest-rspec",
      {
        "folke/neodev.nvim",
        opts = function(_, opts)
          opts.library = opts.library or {}
          if opts.library.plugins ~= true then
            opts.library.plugins = require("astrocore").list_insert_unique(opts.library.plugins, { "neotest" })
          end
          opts.library.types = true
        end,
      },
    },
    opts = function()
      return {
        -- your neotest config here
        adapters = {
          require "neotest-rspec",
        },
      }
    end,
    config = function(_, opts)
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup(opts)
    end,
  },
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
}
