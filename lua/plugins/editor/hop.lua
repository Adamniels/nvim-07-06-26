-- =============================================================================
-- hop.lua — EasyMotion-style jumps
-- =============================================================================
-- hop.nvim is the maintained successor to vim-easymotion. You trigger a motion,
-- every possible target gets a short label, and you type the label to teleport
-- there. smoka7/hop.nvim is the active fork (phaazon/hop.nvim is archived).
--
-- All jumps are under ,, (comma comma). This avoids any clash with
-- mini.surround's `s` mappings.
--
-- KEYMAPS  (n = normal, also work in visual + operator-pending where it makes sense)
--   ,,w   jump to start of a word forward
--   ,,b   jump to start of a word backward
--   ,,e   jump to end of a word forward
--   ,,j   jump to a line below (column-aware, like easymotion j)
--   ,,k   jump to a line above
--   ,,f   jump by typing 1 character
--   ,,s   jump by typing 2 characters (more precise)
--   ,,l   jump to any visible line
-- =============================================================================

return {
  "smoka7/hop.nvim",
  version = "*",
  event = "VeryLazy",

  opts = {
    -- Characters used to build the jump labels, ordered by home-row reachability.
    keys = "etovxqpdygfblzhckisuran",
  },

  config = function(_, opts)
    local hop = require("hop")
    hop.setup(opts)

    local hint = require("hop.hint")
    local AFTER = hint.HintDirection.AFTER_CURSOR
    local BEFORE = hint.HintDirection.BEFORE_CURSOR

    -- Apply jumps in normal, visual, and operator-pending modes so you can also
    -- do things like d<leader><leader>w (delete up to a hopped word).
    local modes = { "n", "x", "o" }
    local function map(lhs, fn, desc)
      vim.keymap.set(modes, lhs, fn, { desc = desc })
    end

    map(",,w", function()
      hop.hint_words({ direction = AFTER })
    end, "Hop word forward")

    map(",,b", function()
      hop.hint_words({ direction = BEFORE })
    end, "Hop word backward")

    map(",,e", function()
      hop.hint_words({ direction = AFTER, hint_position = hint.HintPosition.END })
    end, "Hop word end")

    map(",,j", function()
      hop.hint_vertical({ direction = AFTER })
    end, "Hop line down")

    map(",,k", function()
      hop.hint_vertical({ direction = BEFORE })
    end, "Hop line up")

    map(",,f", function()
      hop.hint_char1()
    end, "Hop to 1 char")

    map(",,s", function()
      hop.hint_char2()
    end, "Hop to 2 chars")

    map(",,l", function()
      hop.hint_lines_skip_whitespace()
    end, "Hop to line")
  end,
}
