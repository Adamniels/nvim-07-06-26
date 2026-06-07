-- =============================================================================
-- lint.lua — async linting
-- =============================================================================
-- nvim-lint runs linters independently of the LSP. This matters because:
--   - Some linters (eslint_d, shellcheck) catch things the LSP misses
--   - Linting and language servers are separate concerns
--   - You can have linting without a full LSP server running
--
-- Linting runs automatically when you:
--   - Open a file
--   - Save a file
--   - Leave insert mode (so you see results after finishing a change)
--
-- All linters below are installed automatically by Mason (see mason.lua).

return {
  "mfussenegger/nvim-lint",

  event = { "BufReadPost", "BufNewFile" },

  config = function()
    local lint = require("lint")

    -- =========================================================================
    -- Linters per filetype
    -- =========================================================================
    lint.linters_by_ft = {
      python          = { "ruff" },
      -- ruff replaces flake8 + isort + pyupgrade. It's orders of magnitude
      -- faster and covers most of what pylint does.

      typescript      = { "eslint_d" },
      javascript      = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      -- eslint_d is the daemon version of eslint — same rules, much faster
      -- because it stays running between lints instead of restarting each time.
      -- It reads your project's .eslintrc / eslint.config.js automatically.

      sh              = { "shellcheck" },
      bash            = { "shellcheck" },
      -- shellcheck is the gold standard for bash linting. It catches quoting
      -- errors, unintended word splitting, and portability issues.
    }

    -- =========================================================================
    -- When to lint
    -- =========================================================================
    vim.api.nvim_create_autocmd(
      { "BufEnter", "BufWritePost", "InsertLeave" },
      {
        group = vim.api.nvim_create_augroup("user_nvim_lint", { clear = true }),
        callback = function()
          -- try_lint is safe to call on any buffer — it silently skips
          -- filetypes that have no linters configured.
          lint.try_lint()
        end,
      }
    )
  end,
}
