-- =============================================================================
-- snacks.lua — snacks.nvim (all features)
-- =============================================================================
-- snacks.nvim is a collection of small, high-quality Neovim utilities by folke.
-- Each feature is independently toggleable via `enabled = true/false`.
--
-- Features configured here:
--   dashboard   — start screen when opening Neovim with no file
--   notifier    — notification toasts (replaces nvim-notify)
--   picker      — fuzzy finder (replaces telescope)
--   terminal    — floating terminal
--   indent      — indent guide lines
--   words       — highlight all occurrences of the word under cursor
--   bigfile     — gracefully handle very large files
--   input       — nicer vim.ui.input dialogs

return {
  "folke/snacks.nvim",
  lazy     = false,
  priority = 1000,

  ---@type snacks.Config
  opts = {

    -- =========================================================================
    -- Dashboard
    -- =========================================================================
    dashboard = {
      enabled = true,

      -- preset defines the content blocks (header and key list)
      preset = {
        header = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        keys = {
          { icon = " ", key = "f", desc = "Find File",    action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "g", desc = "Grep Text",    action = ":lua Snacks.picker.grep()" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "n", desc = "New File",     action = ":ene | startinsert" },
          { icon = "󰒲 ", key = "l", desc = "Lazy",        action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit",         action = ":qa" },
        },
      },

      -- sections defines the layout — what renders and in what order.
      -- Without this, the dashboard renders nothing.
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "recent_files", limit = 5, padding = 1 },
        { section = "startup" },
      },
    },

    -- =========================================================================
    -- Notifier — toast notifications (replaces nvim-notify)
    -- =========================================================================
    notifier = {
      enabled = true,
      timeout = 3000,
      style   = "compact",
    },

    -- =========================================================================
    -- Picker — fuzzy finder (replaces telescope)
    -- =========================================================================
    picker = {
      enabled = true,
    },

    -- =========================================================================
    -- Terminal — floating terminal
    -- =========================================================================
    terminal = {
      enabled = true,
    },

    -- =========================================================================
    -- Input — nicer floating input dialogs
    -- =========================================================================
    input = {
      enabled = true,
    },

    -- =========================================================================
    -- Indent guides
    -- =========================================================================
    indent = {
      enabled = true,
      indent = {
        char = "│",
        hl   = "SnacksIndent",
      },
      scope = {
        enabled = true,
        char    = "│",
        hl      = "SnacksIndentScope",
      },
    },

    -- =========================================================================
    -- Words — highlight other occurrences of word under cursor
    -- =========================================================================
    words = { enabled = true },

    -- =========================================================================
    -- Bigfile — disable heavy features on files > 1.5 MB
    -- =========================================================================
    bigfile = {
      enabled = true,
      size    = 1.5 * 1024 * 1024,
    },

    -- Smooth scroll disabled — enable if you want it
    scroll = { enabled = false },
  },

  -- ==========================================================================
  -- Keys
  -- ==========================================================================
  keys = {

    -- Picker — files
    { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
    { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
    { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent Files" },
    { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },

    -- Picker — grep
    { "<leader>/",  function() Snacks.picker.grep() end,                       desc = "Grep" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, mode = { "n", "x" }, desc = "Grep Word/Selection" },

    -- Picker — buffers & misc
    { "<leader>,", function() Snacks.picker.buffers() end,         desc = "Switch Buffer" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.notifier.show_history() end,  desc = "Notifications" },

    -- Picker — LSP (keymaps available globally; LSP phase adds buffer-local ones)
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
    { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

    -- Picker — git
    { "<leader>gl", function() Snacks.picker.git_log() end,      desc = "Git Log" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log (file)" },

    -- Picker — diagnostics
    { "<leader>xl", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },

    -- Terminal
    { "<leader>ft", function() Snacks.terminal() end,              desc = "Floating Terminal" },
    { "<C-\\>",     function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Toggle Terminal" },

    -- Words — jump between occurrences of word under cursor
    { "]]", function() Snacks.words.jump(1,  true) end, desc = "Next word occurrence" },
    { "[[", function() Snacks.words.jump(-1, true) end, desc = "Prev word occurrence" },
  },
}
