-- =============================================================================
-- noice.lua — command line + message UI
-- =============================================================================
-- noice.nvim replaces several built-in Neovim UI elements with floating windows:
--   - The command line (: / ? mode) becomes a centered floating input
--   - Long messages open in a scrollable split instead of the message area
--   - LSP progress shown as compact status in the corner
--
-- Notifications (vim.notify) are handled by snacks.notifier, NOT noice.

return {
  "folke/noice.nvim",
  event        = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },

  opts = {

    -- snacks.notifier handles vim.notify — tell noice to leave it alone
    notify = {
      enabled = false,
    },

    -- =========================================================================
    -- Routes — suppress specific noisy messages
    -- =========================================================================
    routes = {
      -- Hide "[N lines, M bytes] written" on every save
      {
        filter = { event = "msg_show", find = "%d+L, %d+B" },
        opts   = { skip = true },
      },
      -- Hide search wrap messages ("search hit BOTTOM" etc.)
      {
        filter = { event = "msg_show", find = "search hit" },
        opts   = { skip = true },
      },
      -- Send tall messages to a split instead of squishing into the cmdline area
      {
        filter = { event = "msg_show", min_height = 5 },
        view   = "split",
      },
    },

    -- =========================================================================
    -- LSP — use treesitter to render markdown in hover docs
    -- =========================================================================
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"]               = true,
      },
      progress = {
        enabled  = true,
        throttle = 1000 / 30,
      },
    },

    -- =========================================================================
    -- Presets
    -- =========================================================================
    presets = {
      bottom_search        = true,  -- keep the / search bar at the bottom
      command_palette      = true,  -- : command line opens as a centered popup
      long_message_to_split = true,
      lsp_doc_border       = true,  -- border on LSP hover / signature windows
    },
  },

  keys = {
    -- View noice message history (different from snacks notification history)
    { "<leader>nh", function() require("noice").cmd("history") end,  desc = "Noice History" },
    { "<leader>nd", function() require("noice").cmd("dismiss") end,  desc = "Dismiss Messages" },
  },
}
