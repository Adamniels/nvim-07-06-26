-- =============================================================================
-- mini.lua — mini.pairs + mini.surround + mini.ai
-- =============================================================================
-- mini.nvim is a collection of minimal, single-purpose plugins that share one
-- repo. We use three of them:
--
--   mini.pairs   — auto-close brackets and quotes as you type
--   mini.surround — add/delete/replace surrounding characters (like vim-surround)
--   mini.ai      — smarter text objects: function body, class, argument, quote, etc.
--
-- All three are in one file because they share a single plugin dependency.

return {
  "echasnovski/mini.nvim",
  event = "VeryLazy",

  config = function()

    -- =========================================================================
    -- mini.pairs — auto-close brackets and quotes
    -- =========================================================================
    -- When you type (, [, {, ", ', or `, the closing character is inserted
    -- automatically and the cursor is placed between them.
    -- Pressing the closing character when the cursor is before it moves through
    -- it without inserting a duplicate.
    require("mini.pairs").setup({
      -- Disable auto-pairs in specific filetypes if needed, e.g.:
      -- modes = { insert = true, command = false, terminal = false },
    })

    -- =========================================================================
    -- mini.surround — surround text objects
    -- =========================================================================
    -- Add, delete, or replace surrounding characters.
    --
    -- USAGE:
    --   sa{motion}{char}  — add surround
    --     saiwq   = surround word with single quotes
    --     sa2w"   = surround 2 words with double quotes
    --     saf"    = surround function call with double quotes
    --   sd{char}          — delete surround
    --     sd"     = delete surrounding double quotes
    --     sd(     = delete surrounding parentheses
    --   sr{old}{new}      — replace surround
    --     sr'"    = replace ' with "
    --     sr({    = replace ( with {
    require("mini.surround").setup({
      mappings = {
        add            = "sa",  -- add surrounding   (e.g. saiwq)
        delete         = "sd",  -- delete surrounding (e.g. sd")
        find           = "sf",  -- find surrounding to the right
        find_left      = "sF",  -- find surrounding to the left
        highlight      = "sh",  -- highlight surrounding
        replace        = "sr",  -- replace surrounding (e.g. sr'")
        update_n_lines = "sn",  -- update search range for next operation
      },
    })

    -- =========================================================================
    -- mini.ai — extended text objects
    -- =========================================================================
    -- Extends the built-in a{char}/i{char} text objects with smarter ones.
    -- Works with all standard operators: d, c, y, v, etc.
    --
    -- KEY TEXT OBJECTS (use with a = around / i = inside):
    --   af / if  — function call arguments or function body
    --   ac / ic  — class body
    --   aa / ia  — function argument (the next argument in a list)
    --   aq / iq  — any quote (" ' `)
    --   ab / ib  — any bracket ( [ {
    --   at / it  — HTML/JSX tag
    --
    -- EXAMPLES:
    --   daa   = delete a function argument (including comma)
    --   ciq   = change inside any quote (changes content of "..." or '...')
    --   vaf   = select around function (for visual inspection)
    --   yib   = yank inside any bracket
    require("mini.ai").setup({
      -- How many lines away to search for the next text object.
      -- 500 handles most realistic cases without being too slow.
      n_lines = 500,
    })

  end,
}
