-- =============================================================================
-- bufferline.lua — tab bar showing open buffers
-- =============================================================================
-- bufferline renders open buffers as VSCode-style tabs at the top of the window.
-- Each tab shows: file icon, filename, modified dot, close button.
-- LSP diagnostics appear as small badges per tab.

return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",

  keys = {
    { "<leader>bd", "<cmd>bdelete<CR>",      desc = "Delete Buffer" },
    { "<leader>bD", "<cmd>bdelete!<CR>",     desc = "Delete Buffer (force)" },
    -- Delete all buffers except the current one.
    -- This command: %bd closes all, e# reopens the last, bd# closes the [No Name] buffer.
    { "<leader>bo", "<cmd>%bd|e#|bd#<CR>",   desc = "Delete Other Buffers" },
  },

  opts = {
    options = {
      -- "tabs" mode: the top bar shows Neovim TABPAGES, not buffers.
      -- Opening a file swaps the content of the current tab instead of adding
      -- a new entry. A new tab only appears when you create one (:tabnew).
      mode = "tabs",

      -- Show LSP diagnostic counts on each buffer tab
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local icons = { error = " ", warning = " " }
        local result = {}
        for kind, count in pairs(diag) do
          if icons[kind] then
            table.insert(result, count .. icons[kind])
          end
        end
        return #result > 0 and " " .. table.concat(result, " ") or ""
      end,

      -- Reserve space for neo-tree on the left so the bufferline doesn't
      -- overlap the sidebar. This adds a label at the top of the sidebar area.
      offsets = {
        {
          filetype  = "neo-tree",
          text      = "  Files",
          highlight = "Directory",
          separator = true,
        },
      },

      show_buffer_close_icons = true,
      show_close_icon         = false,  -- don't show a global close icon on the right

      -- Hide the bufferline when only one buffer is open.
      -- It reappears automatically when you open a second file.
      always_show_bufferline = false,

      -- Separator style between tabs. "thin" works well with TokyoNight.
      separator_style = "thin",

      -- Show a number in each tab (useful for :b1, :b2 style navigation)
      numbers = "none",
    },
  },
}
