-- =============================================================================
-- which-key.lua — keybinding hints popup
-- =============================================================================
-- which-key shows a popup listing available keybindings after you press the
-- leader key (or any partial sequence) and pause for a moment.
--
-- It also lets you give meaningful names to key groups so the popup shows
-- "Find / Files" instead of an unlabelled list.
--
-- You never need to memorise your keymaps — just press <leader> and wait.

return {
  "folke/which-key.nvim",
  event = "VeryLazy",

  opts = {
    -- Show icons next to each keymap (uses Nerd Font glyphs)
    icons = { mappings = true },

    -- Delay (ms) before the popup appears.
    -- Inherits vim.o.timeoutlen (300ms) if not set — no need to duplicate it.

    -- ==========================================================================
    -- Key group labels
    -- ==========================================================================
    -- These names show up as section headers in the which-key popup.
    -- Every keybinding we've defined under these prefixes will be grouped here.
    spec = {
      { "<leader>b",  group = "Buffers",        icon = "󰓩 " },
      { "<leader>c",  group = "Code / LSP",     icon = " " },
      { "<leader>d",  group = "Debug",          icon = " " },
      { "<leader>f",  group = "Find / Files",   icon = " " },
      { "<leader>g",  group = "Git",            icon = " " },
      { "<leader>gh", group = "Git Hunks",      icon = " " },
      { "<leader>n",  group = "Notifications",  icon = "󰵅 " },
      { "<leader>s",  group = "Splits",         icon = " " },
      { "<leader>x",  group = "Diagnostics",    icon = " " },
      { "<leader>a",  group = "AI",             icon = "󰚩 " },

      -- These are single-key leaders already defined in keymaps.lua —
      -- giving them names makes them show up cleanly in the popup.
      { "<leader>gb", desc  = "Toggle Line Blame", icon = " " },
      { "<leader>gg", desc  = "Open Neogit",      icon = " " },
      { "<leader>cf", desc  = "Format Buffer",    icon = "󰉢 " },
      { "<leader>w",  desc  = "Save file",        icon = " " },
      { "<leader>q",  desc  = "Quit",        icon = " " },
      { "<leader>Q",  desc  = "Quit all",    icon = " " },
      { "<leader>e",  desc  = "Toggle Explorer", icon = " " },
      { "<leader>E",  desc  = "Reveal in Explorer", icon = " " },
      { "<leader>/",  desc  = "Grep",        icon = " " },
      { "<leader>,",  desc  = "Switch Buffer", icon = "󰓩 " },
      { "<leader>:",  desc  = "Command History", icon = " " },
    },
  },
}
