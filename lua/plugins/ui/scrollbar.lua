-- =============================================================================
-- scrollbar.lua — scrollbar with git and diagnostic markers
-- =============================================================================
-- nvim-scrollbar adds a scrollbar on the right edge of the window showing:
--   - Where you are in the file (the handle)
--   - Git changes (added / changed / deleted) — pulled from gitsigns
--   - Diagnostics (errors / warnings) — pulled from the LSP
--
-- This gives you a bird's-eye view of the whole file at a glance.

return {
  "petertriho/nvim-scrollbar",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "lewis6991/gitsigns.nvim", -- for git change markers
  },

  config = function()
    require("scrollbar").setup({
      -- Position the scrollbar on the right edge
      handle = {
        color = "#3d4257", -- subtle handle color (tokyonight-aware)
      },

      marks = {
        GitAdd = {
          text = "▎",
          color = "#449dab",
        },
        GitChange = {
          text = "▎",
          color = "#6183bb",
        },
        GitDelete = {
          text = "▎",
          color = "#914c54",
        },
        Error = { color = "#db4b4b" },
        Warn  = { color = "#e0af68" },
        Info  = { color = "#0db9d7" },
        Hint  = { color = "#1abc9c" },
      },

      -- Don't show the scrollbar in these filetypes
      excluded_filetypes = {
        "snacks_dashboard",
        "neo-tree",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "help",
        "alpha",
      },

      handlers = {
        cursor      = true,  -- show cursor position on scrollbar
        diagnostic  = true,  -- show LSP errors/warnings
        gitsigns    = true,  -- show git changes (requires gitsigns.nvim)
        handle      = true,
        search      = false, -- search matches (can be noisy)
      },
    })
  end,
}
