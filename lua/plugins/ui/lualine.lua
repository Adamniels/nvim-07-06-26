-- =============================================================================
-- lualine.lua — statusline
-- =============================================================================
-- lualine replaces Neovim's built-in statusline with a fast, configurable one.
-- globalstatus = true means one shared statusline at the bottom, not one per split.
--
-- Layout (left → right):
--   [mode] [branch] [diff] [diagnostics]   filename   [lsp] [filetype] [progress] [location]

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",

  opts = {
    options = {
      theme = "tokyonight",
      -- Powerline-style separators. These use Nerd Font glyphs.
      -- If you ever switch to a non-Nerd Font, change these to "" (empty string).
      component_separators = { left = "", right = "" },
      section_separators   = { left = "", right = "" },
      globalstatus = true,    -- single statusline across all windows (Neovim 0.7+)
      disabled_filetypes = {
        -- snacks dashboard filetype is "snacks_dashboard" — hide statusline there
        statusline = { "snacks_dashboard" },
      },
    },

    sections = {
      -- Left side
      lualine_a = { "mode" },

      lualine_b = {
        "branch",
        -- Git diff stats (insertions, deletions, modifications)
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
        },
        -- Diagnostics count from LSP
        {
          "diagnostics",
          symbols = { error = " ", warn = " ", info = " ", hint = "󰝶 " },
        },
      },

      -- Center — filename with relative path
      lualine_c = {
        {
          "filename",
          path = 1,   -- 0 = just filename, 1 = relative path, 2 = absolute path
          symbols = {
            modified = "●",   -- dot when file has unsaved changes
            readonly = "",   -- lock icon for read-only files
            unnamed  = "[No Name]",
          },
        },
      },

      -- Right side
      lualine_x = {
        -- Show active LSP client names for the current buffer.
        -- Returns empty string when no LSP is attached so nothing shows.
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return "" end
            local names = vim.tbl_map(function(c) return c.name end, clients)
            return " " .. table.concat(names, " + ")
          end,
          color = { fg = "#7dcfff" },  -- tokyonight cyan
        },
        "filetype",
      },

      lualine_y = { "progress" },  -- percentage through file
      lualine_z = { "location" },  -- line:column
    },

    -- Statusline shown in inactive (unfocused) windows
    inactive_sections = {
      lualine_c = {
        { "filename", path = 1 },
      },
      lualine_x = { "location" },
    },
  },
}
