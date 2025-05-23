-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local og_virt_text
local og_virt_line

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = true, -- diagnostic settings on startup
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      virtual_lines = { current_line = true },
      underline = true,
      update_in_insert = false,
    },
    autocmds = {
      diagnostic_only_virtlines = {
        {
          event = { "CursorMoved", "DiagnosticChanged" },
          callback = function()
            if not require("astrocore.buffer").is_valid() then return end
            if og_virt_line == nil then og_virt_line = vim.diagnostic.config().virtual_lines end

            -- ignore if virtual_lines.current_line is disabled
            if not (og_virt_line and og_virt_line.current_line) then
              if og_virt_text then
                vim.diagnostic.config { virtual_text = og_virt_text }
                og_virt_text = nil
              end
              return
            end

            if og_virt_text == nil then og_virt_text = vim.diagnostic.config().virtual_text end

            local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

            if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum })) then
              vim.diagnostic.config { virtual_text = og_virt_text }
            else
              vim.diagnostic.config { virtual_text = false }
            end
          end,
        },
        {
          event = "ModeChanged",
          callback = function()
            if require("astrocore.buffer").is_valid() then pcall(vim.diagnostic.show) end
          end,
        },
      },
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        jbuilder = "ruby",
        ["html.erb"] = "eruby",
      },
      filename = {
        ["Capfile"] = "ruby",
        ["Guardfile"] = "ruby",
        ["Vagrantfile"] = "ruby",
      },
      pattern = {
        -- [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        conceallevel = 1,
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        scrolloff = 10,
        spell = true, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = true, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        --
        -- https://github.com/alvan/vim-closetag
        closetag_filenames = "*.html,*.html.erb",
        closetag_filetypes = "html,eruby",

        tokyonight_style = "storm", -- "night", storm", "day"

        ["test#strategy"] = "toggleterm",
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        ["\\"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
        ["<leader>sw"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "Substiture word" },

        [",fp"] = { ":let @+ = expand('%:p')<CR>", desc = "Copy file path" },
        [",fn"] = { ":let @+ = expand('%:n')<CR>", desc = "Copy file name" },

        -- Make page up and down center on the screen
        ["<C-d>"] = { "<C-d>zz" },
        ["<C-u>"] = { "<C-u>zz" },

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },

      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },

      v = { -- Move visually selected lines up and down
        ["J"] = { ":m '>+1<CR>gv=gv" },
        ["K"] = { ":m '<-2<CR>gv=gv" },
      },

      x = {
        ["<leader>P"] = { [["_dP]], desc = "Paste without copying what you pasted over" },
      },
    },
  },
}
