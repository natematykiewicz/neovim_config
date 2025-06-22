return {
  "Saghen/blink.cmp",
  opts = {
    sources = {
      providers = {
        -- defaults to `{ 'buffer' }`
        -- "By default, the buffer source will only show when the LSP source is disabled or returns no items.
        -- You may always show the buffer source via:"
        lsp = { fallbacks = {} },
      },
    },
  },
}
