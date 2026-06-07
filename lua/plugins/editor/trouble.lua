-- =============================================================================
-- trouble.lua — project-wide diagnostics, references, and TODOs
-- =============================================================================
-- Trouble gives you a persistent panel for browsing all problems in your
-- project in one place, instead of jumping through the quickfix list.
--
-- MODES
--   diagnostics   — all LSP errors and warnings across open files
--   lsp           — definitions, references, implementations for symbol under cursor
--   loclist       — current window's location list
--   quickfix      — the quickfix list
--   todo          — all TODO/FIXME/HACK comments (via todo-comments.nvim)
--
-- KEYMAPS
--   <leader>xx    toggle diagnostics panel (all errors and warnings)
--   <leader>xX    toggle diagnostics for current buffer only
--   <leader>xl    toggle location list
--   <leader>xq    toggle quickfix list
--   <leader>cs    LSP document symbols (outline of current file)
--   <leader>xt    TODOs (defined in todo-comments.lua)
--
-- INSIDE THE TROUBLE PANEL
--   <CR>          jump to the item
--   o             jump and close trouble
--   q             close trouble
--   r             refresh
--   ?             show keybindings

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd  = "Trouble",

  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",                        desc = "Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",           desc = "Buffer Diagnostics (Trouble)" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>",                            desc = "Location List (Trouble)" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                             desc = "Quickfix List (Trouble)" },
    { "<leader>cs", "<cmd>Trouble lsp_document_symbols toggle focus=false<CR>",   desc = "Symbols (Trouble)" },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          vim.cmd.cprev()
        end
      end,
      desc = "Prev Trouble / Quickfix",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          vim.cmd.cnext()
        end
      end,
      desc = "Next Trouble / Quickfix",
    },
  },

  opts = {
    modes = {
      -- Tweak the default diagnostics view
      diagnostics = {
        -- Group diagnostics by file, then by severity
        groups = { { "filename", format = "{file_icon} {basename:Title} {count}" } },
        sort   = { "severity", "filename", "pos" },
      },
    },
  },
}
