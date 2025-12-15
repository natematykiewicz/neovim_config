return {
  "AstroNvim/astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    table.insert(opts.servers, "herb_ls")

    opts.config = require("astrocore").extend_tbl(opts.config or {}, {
      herb_ls = {
        cmd = {
          "herb-language-server",
          "--stdio",
        },
        filetypes = {
          "html",
          "eruby",
          "erb",
          "markdown",
        },
        root_dir = require("lspconfig.util").root_pattern("Gemfile", ".git"),
      },
    })
  end,
}
