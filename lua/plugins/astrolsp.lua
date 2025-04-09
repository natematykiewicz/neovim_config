-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local function tprint(tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if type(k) == "number" then
      toprint = toprint .. "[" .. k .. "] = "
    elseif type(k) == "string" then
      toprint = toprint .. k .. "= "
    end
    if type(v) == "number" then
      toprint = toprint .. v .. ",\r\n"
    elseif type(v) == "string" then
      toprint = toprint .. '"' .. v .. '",\r\n'
    elseif type(v) == "table" then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. '"' .. tostring(v) .. '",\r\n'
    end
  end
  toprint = toprint .. string.rep(" ", indent - 2) .. "}"
  return toprint
end

local function add_ruby_deps_command(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "ShowRubyDeps", function(opts)
    local params = vim.lsp.util.make_text_document_params()
    local showAll = opts.args == "all"

    client.request("rubyLsp/workspace/dependencies", params, function(error, result)
      if error then
        print("Error showing deps: " .. error)
        return
      end

      local qf_list = {}
      for _, item in ipairs(result) do
        if showAll or item.dependency then
          table.insert(qf_list, {
            text = string.format("%s (%s) - %s", item.name, item.version, item.dependency),
            filename = item.path,
          })
        end
      end

      vim.fn.setqflist(qf_list)
      vim.cmd "copen"
    end, bufnr)
  end, { nargs = "?", complete = function() return { "all" } end })
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
      -- "tailwindcss",
      -- "solargraph",
      -- "ruby_lsp",
      "sorbet",
      -- "html",
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      solargraph = {
        autoformat = true,
        completion = true,
        -- useBundler = true,
        diagnostic = true,
        logLevel = "debug",
        folding = true,
        references = true,
        formatting = true,
        rename = true,
        symbols = true,
      },
      html = {
        filetypes = { "html", "eruby", "eruby.html" },
        init_options = {
          provideFormatter = false,
          embeddedLanguages = { css = true, javascript = true, ruby = true },
          configurationSection = { "html", "css", "javascript", "eruby", "ruby" },
        },
      },
      ruby_lsp = {
        -- commands = {
        --   ["rubyLsp.openFile"] = {
        --     ---@param command lsp.Command
        --     ---@param ctx table
        --     function(command, ctx)
        --       vim.notify(command.command)
        --       vim.notify(command.title)
        --       vim.notify(command.arguments[0])
        --
        --       for key, value in ctx do
        --         vim.notify(string.format("%s: %s", key, value))
        --       end
        --     end,
        --   },
        -- },
        -- init_options = {
        --   featuresConfiguration = {
        --     inlayHint = {
        --       -- enableAll = true,
        --     },
        --   },
        -- },
        commands_created = true,
        on_attach = function(client, buffer)
          client.commands["rubyLsp.openFile"] = function(command)
            local uri = command.arguments[1][1]
            local path = uri:gsub("^file://", "")

            vim.cmd("e " .. path)
          end

          client.commands["rubyLsp.runTask"] = function(command)
            local shell_command = command.arguments[1]
            vim.notify("Running: " .. shell_command)
            vim.cmd "split"
            vim.cmd("terminal " .. shell_command)
          end

          client.commands["rubyLsp.runTest"] = function(command, context)
            require("neotest").run.run()
            vim.notify(tprint(command))
            vim.notify(tprint(context))
          end

          client.commands["rubyLsp.runTestInTerminal"] = function(command)
            local shell_command = command.arguments[3]
            vim.cmd "split"
            vim.cmd("terminal " .. shell_command)
          end

          client.commands["rubyLsp.debugTest"] = function(command, context)
            vim.notify(tprint(command))
            vim.notify(tprint(context))
          end

          add_ruby_deps_command(client, buffer)
        end,
      },
      sorbet = {
        root_dir = function(fname)
          local root_pattern = require("lspconfig").util.root_pattern "sorbet/config"
          return root_pattern(fname)
        end,
      },
      tailwindcss = {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                "class: \"|'([^\"|']*)",
              },
            },
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              global = { "vim" },
            },
          },
        },
      },
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },

    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
