-- =============================================================================
-- gitsigns.lua — inline git decorations and hunk operations
-- =============================================================================
-- gitsigns shows what changed in the current file compared to git HEAD:
--
--   │ in the gutter — added lines
--   │ in the gutter — changed lines
--   │ in the gutter — deleted lines (shown as a small mark at the boundary)
--
-- It also lets you stage, reset, and navigate individual hunks without leaving
-- the file you're editing — no need to open a full git UI for small changes.
--
-- HUNK NAVIGATION
--   ]h / [h  — jump to next / previous hunk
--
-- HUNK ACTIONS (normal mode)
--   <leader>ghs  — stage hunk under cursor
--   <leader>ghr  — reset (discard) hunk under cursor
--   <leader>ghS  — stage entire file
--   <leader>ghR  — reset entire file
--   <leader>ghp  — preview hunk diff in a floating window
--   <leader>ghb  — show git blame for current line (floating)
--   <leader>ghd  — diff current file against HEAD
--
-- HUNK ACTIONS (visual mode — operate on selected lines only)
--   <leader>ghs  — stage selected lines
--   <leader>ghr  — reset selected lines

return {
  "lewis6991/gitsigns.nvim",

  -- Load as soon as a buffer is read — we want signs from the start
  event = { "BufReadPre", "BufNewFile" },

  opts = {
    -- =========================================================================
    -- Sign appearance
    -- =========================================================================
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
      untracked    = { text = "▎" },
    },

    -- =========================================================================
    -- Features
    -- =========================================================================
    -- Show blame annotation at end of current line (toggleable)
    current_line_blame = false, -- off by default, toggle with <leader>gb

    current_line_blame_opts = {
      virt_text         = true,
      virt_text_pos     = "eol",
      delay             = 800,  -- ms before the blame text appears
      ignore_whitespace = false,
    },

    -- =========================================================================
    -- Keymaps
    -- =========================================================================
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, keys, func, desc)
        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
      end

      -- Hunk navigation
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Hunk")

      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev Hunk")

      -- Hunk actions (normal + visual)
      map({ "n", "v" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>",  "Stage Hunk")
      map({ "n", "v" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>",  "Reset Hunk")

      -- File-level actions
      map("n", "<leader>ghS", gs.stage_buffer,              "Stage File")
      map("n", "<leader>ghR", gs.reset_buffer,              "Reset File")
      map("n", "<leader>ghu", gs.undo_stage_hunk,           "Undo Stage Hunk")

      -- Inspection
      map("n", "<leader>ghp", gs.preview_hunk,              "Preview Hunk")
      map("n", "<leader>ghb", gs.blame_line,                "Blame Line")
      map("n", "<leader>gb",  gs.toggle_current_line_blame, "Toggle Line Blame")
      map("n", "<leader>ghd", gs.diffthis,                  "Diff File")

      -- Text object — use ih (inner hunk) with any operator
      -- e.g.vih = select hunk, dih = delete hunk
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
    end,
  },
}
