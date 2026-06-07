-- =============================================================================
-- lsp.lua — LSP server configuration
-- =============================================================================
-- Neovim 0.11+ has a built-in LSP client with a new, clean API:
--
--   vim.lsp.config(name, opts)  — define a server's settings
--   vim.lsp.enable(name)        — activate it for matching filetypes
--
-- nvim-lspconfig is now a data-only package. It provides default cmd/filetypes
-- for each server so we don't have to specify them from scratch. We only need
-- to override the parts we want to customise (settings, capabilities, etc.).
--
-- ARCHITECTURE
-- ┌─────────────┐   installs    ┌──────────────────┐
-- │    Mason    │ ────────────▶ │  lua-ls, pyright, │
-- └─────────────┘               │  ts_ls, etc.      │
--                               └──────────────────┘
-- ┌─────────────┐   provides    ┌──────────────────┐
-- │  blink.cmp  │ ────────────▶ │  capabilities    │
-- └─────────────┘               └──────────────────┘
--         │                             │
--         └─────────┐       ┌───────────┘
--                   ▼       ▼
--              vim.lsp.config("*", { capabilities })
--              vim.lsp.config("lua_ls",  { settings })
--              vim.lsp.config("pyright", { settings })
--              ...
--              vim.lsp.enable({ "lua_ls", "pyright", ... })

return {
  "neovim/nvim-lspconfig",
  -- nvim-lspconfig is data-only as of Neovim 0.11 — no setup() call needed.
  -- We depend on it so lazy.nvim loads it, giving us the default server configs.
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },

  config = function()

    -- ==========================================================================
    -- Global capabilities (applied to every server)
    -- ==========================================================================
    -- blink.cmp extends the default capabilities to tell servers that Neovim
    -- can handle richer completions: snippets, label details, insert-replace, etc.
    -- Setting "*" means this merges into all per-server configs automatically.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    -- ==========================================================================
    -- Server configurations
    -- ==========================================================================
    -- We only set what we want to customise. nvim-lspconfig fills in the
    -- defaults (cmd, filetypes, root_dir) for each server.

    -- Lua — tuned for Neovim config editing
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT", -- Neovim uses LuaJIT, not standard Lua
          },
          workspace = {
            checkThirdParty = false,
            -- Make lua_ls aware of Neovim's built-in API and all installed plugins.
            -- Without this, vim.* calls would be flagged as undefined.
            library = vim.api.nvim_get_runtime_file("", true),
          },
          diagnostics = {
            globals = { "vim" }, -- don't warn about the `vim` global
          },
          telemetry = { enable = false },
        },
      },
    })

    -- Python — pyright is fast and strict
    vim.lsp.config("pyright", {
      settings = {
        python = {
          analysis = {
            autoSearchPaths     = true,
            -- "openFilesOnly" means only analyse files you have open.
            -- Change to "workspace" if you want project-wide diagnostics.
            diagnosticMode      = "openFilesOnly",
            useLibraryCodeForTypes = true,
          },
        },
      },
    })

    -- TypeScript / JavaScript
    -- ts_ls is the official TypeScript language server (formerly tsserver)
    vim.lsp.config("ts_ls", {
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints         = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints          = true,
            includeInlayReturnTypeHints            = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints         = "all",
            includeInlayReturnTypeHints            = true,
          },
        },
      },
    })

    -- C# — csharp_ls is lightweight and doesn't require the full .NET SDK
    -- For heavier Roslyn features (rename across files, etc.) switch to omnisharp
    vim.lsp.config("csharp_ls", {})

    -- Bash
    vim.lsp.config("bashls", {})

    -- Rust — configured but NOT installed via Mason.
    -- Install with: rustup component add rust-analyzer
    -- rustup ensures the analyzer version matches your active Rust toolchain.
    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          -- Run clippy instead of cargo check on save — catches more issues
          check = { command = "clippy" },
          inlayHints = {
            bindingModeHints      = { enable = true },
            closureReturnTypeHints = { enable = "always" },
            lifetimeElisionHints  = { enable = "skip_trivial" },
          },
        },
      },
    })

    -- ==========================================================================
    -- Enable servers
    -- ==========================================================================
    -- This activates each server for its default filetypes. For example,
    -- lua_ls activates for *.lua, pyright for *.py, ts_ls for *.ts/*.js, etc.
    vim.lsp.enable({
      "lua_ls",
      "pyright",
      "ts_ls",
      "csharp_ls",
      "bashls",
      "rust_analyzer",
    })

    -- ==========================================================================
    -- Keymaps — added when an LSP attaches to a buffer
    -- ==========================================================================
    -- LspAttach fires every time a language server connects to a buffer.
    -- We use it to set buffer-local keymaps that are only active when an LSP
    -- is running. This way these keys don't conflict in plain text files.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true }),
      callback = function(event)

        local function map(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
        end

        -- Navigation
        -- gd / gD / gi / gy go somewhere in code. gr finds all references.
        map("gd", vim.lsp.buf.definition,      "Go to Definition")
        map("gD", vim.lsp.buf.declaration,     "Go to Declaration")
        map("gi", vim.lsp.buf.implementation,  "Go to Implementation")
        map("gy", vim.lsp.buf.type_definition, "Go to Type Definition")
        map("gr", vim.lsp.buf.references,      "Find References")

        -- Documentation
        -- K is the traditional Vim help key — here it shows hover docs from LSP
        map("K",     vim.lsp.buf.hover,          "Hover Documentation")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")

        -- Code actions
        map("<leader>ca", vim.lsp.buf.code_action,    "Code Action")
        map("<leader>cr", vim.lsp.buf.rename,         "Rename Symbol")
        map("<leader>cw", vim.lsp.buf.workspace_symbol, "Workspace Symbols")

        -- Diagnostics
        -- cd shows the full message for the diagnostic under the cursor
        map("<leader>cd", vim.diagnostic.open_float, "Show Diagnostic")
        map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev Diagnostic")
        map("]d", function() vim.diagnostic.jump({ count =  1, float = true }) end, "Next Diagnostic")
        map("[e", function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end, "Prev Error")
        map("]e", function() vim.diagnostic.jump({ count =  1, float = true, severity = vim.diagnostic.severity.ERROR }) end, "Next Error")

      end,
    })

    -- ==========================================================================
    -- Diagnostic display
    -- ==========================================================================
    vim.diagnostic.config({
      -- Show diagnostic messages as virtual text at the end of each line.
      -- Only shows the most severe diagnostic per line to reduce noise.
      virtual_text = {
        spacing  = 4,
        prefix   = "●",
        severity = { min = vim.diagnostic.severity.WARN },
      },

      -- Signs in the gutter (the column left of line numbers)
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN]  = " ",
          [vim.diagnostic.severity.HINT]  = "󰠠 ",
          [vim.diagnostic.severity.INFO]  = " ",
        },
      },

      underline        = true,
      update_in_insert = false, -- don't flash diagnostics while you're typing
      severity_sort    = true,  -- errors at top, hints at bottom

      -- The floating window shown by vim.diagnostic.open_float / <leader>cd
      float = {
        border = "rounded",
        source = true, -- show which LSP server reported the diagnostic
      },
    })

  end,
}
