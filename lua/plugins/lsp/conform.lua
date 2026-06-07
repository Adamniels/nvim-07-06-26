-- =============================================================================
-- conform.lua — code formatting
-- =============================================================================
-- conform.nvim runs formatters on your code. It's faster and more reliable
-- than using LSP formatting because:
--   - It can chain multiple formatters (e.g. prettier then eslint_d)
--   - It formats asynchronously so Neovim doesn't freeze
--   - It falls back to LSP formatting if no formatter is configured
--
-- FORMAT ON SAVE is enabled by default. To temporarily disable it:
--   :lua vim.g.disable_autoformat = true
-- To re-enable:
--   :lua vim.g.disable_autoformat = false
--
-- MANUAL FORMAT: <leader>cf
--
-- TOOL INSTALL: all formatters below are installed automatically by Mason
-- (see mason.lua). Exception: rustfmt comes with rustup.
--   rustup component add rustfmt

return {
  "stevearc/conform.nvim",

  -- Load before saving so format-on-save is always ready
  event = { "BufWritePre" },
  cmd   = { "ConformInfo" },

  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      desc = "Format Buffer",
    },
  },

  opts = {
    -- =========================================================================
    -- Formatters per filetype
    -- =========================================================================
    -- Each entry is a list of formatters to run in sequence.
    -- The first one that is installed and succeeds wins; the rest are skipped,
    -- unless you use the stop_after_first = false option.
    formatters_by_ft = {
      lua              = { "stylua" },

      python           = { "ruff_format" },
      -- ruff_format is ruff's built-in formatter (similar to black).
      -- ruff also handles import sorting automatically.

      typescript       = { "prettier" },
      javascript       = { "prettier" },
      typescriptreact  = { "prettier" },
      javascriptreact  = { "prettier" },
      json             = { "prettier" },
      jsonc            = { "prettier" },
      yaml             = { "prettier" },
      css              = { "prettier" },
      html             = { "prettier" },
      markdown         = { "prettier" },

      cs               = { "csharpier" },

      sh               = { "shfmt" },
      bash             = { "shfmt" },

      rust             = { "rustfmt" },
      -- rustfmt is installed via: rustup component add rustfmt
      -- It reads rustfmt.toml or Cargo.toml [fmt] section for settings.
    },

    -- =========================================================================
    -- Format on save
    -- =========================================================================
    format_on_save = function(bufnr)
      -- Allow disabling format-on-save globally or per-buffer at runtime.
      -- Set vim.g.disable_autoformat = true to disable for the session.
      -- Set vim.b[bufnr].disable_autoformat = true to disable for one buffer.
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      return {
        timeout_ms = 1000,
        -- "fallback": if no formatter is configured for this filetype,
        -- try the LSP's built-in formatting instead
        lsp_format = "fallback",
      }
    end,

    -- =========================================================================
    -- Formatter options
    -- =========================================================================
    formatters = {
      shfmt = {
        -- -i 2: indent with 2 spaces (matching our global shiftwidth)
        -- -ci:  indent switch cases
        prepend_args = { "-i", "2", "-ci" },
      },
    },
  },
}
