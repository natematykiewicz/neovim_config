-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Tpope's vim-rails sets the filetype of a lot of Rails yaml files to eruby.yaml,
-- but treesitter highlights those horribly. Basically all white.
-- Just revert it back to yaml...
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    if vim.bo.filetype == "eruby.yaml" then vim.bo.filetype = "yaml" end
  end,
})

vim.o.guifont = "MonoLisa:h11"

-- Delete trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    local save_cursor = vim.fn.getpos "."
    pcall(function() vim.cmd [[%s/\s\+$//e]] end)
    vim.fn.setpos(".", save_cursor)
  end,
})
