--https://github.com/AstroNvim/astrocommunity/blob/7c1a46d51e0c52f05ebc9b11d466ef9d9464c066/lua/astrocommunity/git/codediff-nvim/init.lua

---@type LazySpec
return {
  "esmuellert/codediff.nvim",
  event = "User AstroGitFile",
  cmd = "CodeDiff",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    keymaps = {
      -- Had to change the defaults because <leader>c closes files
      conflict = {
        accept_incoming = "<leader>Dt", -- Accept incoming (theirs/left) change
        accept_current = "<leader>Do", -- Accept current (ours/right) change
        accept_both = "<leader>Db", -- Accept both changes (incoming first)
        discard = "<leader>Dx", -- Discard both, keep base
        -- Accept all (whole file) - uppercase versions
        accept_all_incoming = "<leader>DT", -- Accept ALL incoming changes
        accept_all_current = "<leader>DO", -- Accept ALL current changes
        accept_all_both = "<leader>DB", -- Accept ALL both changes
        discard_all = "<leader>DX", -- Discard ALL, reset to base

        next_conflict = "]x", -- Jump to next conflict
        prev_conflict = "[x", -- Jump to previous conflict
        diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
        diffget_current = "3do", -- Get hunk from current (right/ours) buffer
      },
    },
  },
}
