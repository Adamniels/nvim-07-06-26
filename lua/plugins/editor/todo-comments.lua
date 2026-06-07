-- =============================================================================
-- todo-comments.lua — highlight and search TODO comments
-- =============================================================================
-- Highlights special comment keywords throughout your code:
--
--   TODO    — something to do
--   FIXME   — broken and needs fixing
--   HACK    — a workaround, revisit later
--   WARN    — pay attention here
--   NOTE    — informational
--   PERF    — performance concern
--   TEST    — test-related note
--
-- Each keyword gets a distinct color so they stand out from regular comments.
--
-- KEYMAPS
--   ]t / [t        jump to next / previous TODO in the file
--   <leader>xt     open all TODOs in Trouble (project-wide list)
--   <leader>xT     open TODOs in the quickfix list

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPost", "BufNewFile" },

  keys = {
    { "]t",         function() require("todo-comments").jump_next() end, desc = "Next TODO" },
    { "[t",         function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
    { "<leader>xt", "<cmd>Trouble todo toggle<CR>",                      desc = "TODOs (Trouble)" },
    { "<leader>xT", "<cmd>TodoQuickFix<CR>",                             desc = "TODOs (Quickfix)" },
  },

  opts = {
    -- Show an icon in the sign column next to TODO comments
    signs = true,

    keywords = {
      FIX  = { icon = " ", color = "error",   alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = "󰅒 ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = "󰋽 ", color = "hint",    alt = { "INFO" } },
      TEST = { icon = "⏲ ", color = "test",    alt = { "TESTING", "PASSED", "FAILED" } },
    },
  },
}
