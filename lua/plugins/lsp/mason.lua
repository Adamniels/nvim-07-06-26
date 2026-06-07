-- =============================================================================
-- mason.lua — LSP server / tool installer
-- =============================================================================
-- Mason is a package manager that lives inside Neovim. It downloads and manages
-- LSP servers, formatters, linters, and debug adapters for you.
--
-- Open the Mason UI with :Mason to browse, install, and update packages.
-- Packages are stored in vim.fn.stdpath("data") .. "/mason/"
--
-- mason-lspconfig bridges Mason with the standard LSP server names (lua_ls,
-- pyright, ts_ls, etc.) so we don't have to remember Mason's internal package
-- names (lua-language-server, pyright, typescript-language-server, ...).
--
-- mason-tool-installer handles the non-LSP tools: formatters and linters.
-- These use Mason's package names directly (stylua, ruff, prettier, etc.).

return {

  -- ============================================================================
  -- Mason core
  -- ============================================================================
  {
    "williamboman/mason.nvim",
    cmd   = "Mason",
    build = ":MasonUpdate",

    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- ============================================================================
  -- mason-lspconfig — auto-install LSP servers
  -- ============================================================================
  -- ensure_installed: automatically download these servers if missing.
  -- After first launch, run :MasonUpdate to keep them current.
  --
  -- NOTE: rust_analyzer is intentionally NOT listed here.
  -- Rust's toolchain (including rust-analyzer) is managed by rustup.
  -- Installing it through Mason can cause version mismatches with your active
  -- toolchain. Instead, install it with:
  --   rustup component add rust-analyzer
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },

    opts = {
      ensure_installed = {
        "lua_ls",    -- Lua (for editing this Neovim config)
        "pyright",   -- Python
        "ts_ls",     -- TypeScript + JavaScript
        "bashls",    -- Bash
        "csharp_ls", -- C#
      },
    },
  },

  -- ============================================================================
  -- mason-tool-installer — auto-install formatters and linters
  -- ============================================================================
  -- Mason can install more than LSP servers. This plugin auto-installs the
  -- formatters and linters that conform.nvim and nvim-lint use.
  --
  -- NOTE: rustfmt is excluded — it comes with rustup (rustup component add rustfmt)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },

    opts = {
      ensure_installed = {
        "stylua",     -- Lua formatter
        "ruff",       -- Python formatter + linter (replaces black + flake8)
        "prettier",   -- TypeScript, JavaScript, JSON, CSS, HTML, Markdown
        "eslint_d",   -- JavaScript / TypeScript linter (fast daemon version)
        "csharpier",  -- C# formatter
        "shfmt",      -- Bash / shell formatter
        "shellcheck", -- Bash / shell linter
      },
    },
  },
}
