-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Kanagawa fixes
-- vim.cmd "hi! link NeotestFailed RedSign"
-- vim.cmd "hi! link NeotestPassed GreenSign"
-- vim.cmd "hi! link NeotestRunning YellowSign"
-- vim.cmd "hi! link NeotestSkipped AquaSign"

-- Make Ruby instance variables and class variables highlight better
-- https://github.com/tree-sitter/tree-sitter-ruby/issues/184
-- vim.cmd "hi! link @label.ruby @property"

-- Better differentiate Ruby symbols from other syntax
-- This also makes JS rest parameters and Ruby keyword arguments the same color
-- vim.cmd "hi! link @symbol.ruby @variable.parameter"

-- This fixes something that broke in Toykonight 3.0
-- Keyword args and symbols were being highlighted purple. It's possible this will
-- be unnecessary when I upgrade to Neovim 0.10.
-- Also, lua hash keys became purple instead of teal
-- vim.cmd "hi! link Identifier @variable.parameter"
-- vim.cmd "hi! link @field @variable.member"
-- vim.cmd "hi! link @type.ruby Constant"

-- Change semantic token color
-- vim.cmd "hi! link @lsp.type.namespace.ruby Type"

-- TODO: fix this
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   callback = function() require("lint").try_lint() end,
-- })

-- Tpope's vim-rails sets the filetype of a lot of Rails yaml files to eruby.yaml,
-- but treesitter highlights those horribly. Basically all white.
-- Just revert it back to yaml...
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    if vim.bo.filetype == "eruby.yaml" then vim.bo.filetype = "yaml" end
  end,
})

-- Set up custom filetypes
vim.filetype.add {
  extension = {
    jbuilder = "ruby",
    ["html.erb"] = "eruby",
  },
  filename = {
    ["Capfile"] = "ruby",
    ["Guardfile"] = "ruby",
    ["Vagrantfile"] = "ruby",
  },
}
