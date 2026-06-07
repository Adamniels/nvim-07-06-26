-- =============================================================================
-- treesitter.lua — syntax highlighting, indentation, folding
-- =============================================================================
-- nvim-treesitter (main branch, Neovim 0.11+) completely changed its API.
-- The old require("nvim-treesitter.configs").setup({}) is removed.
--
-- New model:
--   - Parser installation → require("nvim-treesitter").install({...})
--   - Highlighting        → vim.treesitter.start()          (built into Neovim)
--   - Folding             → vim.treesitter.foldexpr()        (built into Neovim)
--   - Indentation         → require("nvim-treesitter").indentexpr() (plugin)
--
-- All three features are enabled per-buffer via a FileType autocmd so they
-- only activate for filetypes that actually have a parser installed.

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  -- Load immediately — treesitter is foundational and needs to be available
  -- before the first buffer's FileType event fires.
  lazy = false,

  config = function()
    -- =========================================================================
    -- Parser installation
    -- =========================================================================
    -- Installs parsers that are not yet present. Idempotent — already-installed
    -- parsers are skipped. Add more languages here as you need them, or run
    -- :TSInstall <lang> for one-off installs.
    require("nvim-treesitter").install({
      "bash",
      "c_sharp",
      "css",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "query",           -- treesitter query language (useful when editing ts configs)
      "regex",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    })

    -- =========================================================================
    -- Global fold settings
    -- =========================================================================
    -- These are window-local defaults. The FileType autocmd below sets them
    -- per-window whenever a buffer with a treesitter parser is loaded.
    vim.opt.foldlevel      = 99   -- start with everything unfolded
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable     = true
    vim.opt.foldtext       = ""   -- show the actual first line, not a summary (0.10+)

    -- =========================================================================
    -- Enable treesitter features per filetype
    -- =========================================================================
    -- This autocmd runs every time a FileType is set (i.e. every time a buffer
    -- is assigned a language). It tries to activate treesitter features for
    -- that language and silently skips filetypes with no parser.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(event)

        -- Syntax highlighting (native Neovim)
        -- pcall: fails silently if no parser exists for this filetype
        local ok = pcall(vim.treesitter.start, event.buf)
        if not ok then return end

        -- Folding based on code structure, not indentation
        -- za = toggle fold, zR = open all, zM = close all
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr   = "v:lua.vim.treesitter.foldexpr()"

        -- Indentation based on the AST — smarter than regex-based filetype indent
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
