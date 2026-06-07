-- =============================================================================
-- neogit.lua — full git UI (Magit-style)
-- =============================================================================
-- Neogit is a full-featured git interface inspired by Emacs Magit.
-- Use it for commits, branching, rebasing, pushing, pulling, and history.
-- Use gitsigns (gitsigns.lua) for quick per-hunk staging without leaving a file.
--
-- OPEN:  <leader>gg
--
-- INSIDE THE NEOGIT BUFFER:
--   s          — stage file or hunk under cursor
--   u          — unstage file or hunk
--   c          — open commit popup
--   b          — open branch popup
--   P          — open push popup
--   p          — open pull popup
--   r          — open rebase popup
--   l          — open log popup
--   Z          — open stash popup
--   ?          — show all keybindings
--   q          — close neogit
--   Tab        — expand / collapse section

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Optional but recommended: shows diffs inside neogit with better UI
    "sindrets/diffview.nvim",
  },

  cmd  = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<CR>", desc = "Open Neogit" },
  },

  opts = {
    -- =========================================================================
    -- Graph style
    -- =========================================================================
    -- "unicode" uses box-drawing characters for the commit graph.
    -- Change to "ascii" if your font doesn't render them correctly.
    graph_style = "unicode",

    -- =========================================================================
    -- Integrations
    -- =========================================================================
    integrations = {
      -- Use diffview.nvim for viewing diffs inside neogit (d key on a file)
      diffview = true,
    },

    -- =========================================================================
    -- Signs
    -- =========================================================================
    signs = {
      -- Signs shown next to sections in the status buffer
      hunk   = { "", "" },
      item   = { "", "" },
      section = { "", "" },
    },
  },
}
