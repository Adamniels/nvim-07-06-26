-- =============================================================================
-- blink.lua — completion engine
-- =============================================================================
-- blink.cmp is a completion plugin written in Rust. It's significantly faster
-- than nvim-cmp and has a cleaner API.
--
-- It plugs into the LSP to get completions, but also pulls from:
--   lsp      — functions, methods, types from the language server
--   path     — file system paths
--   snippets — built-in snippet engine (no luasnip required)
--   buffer   — words already present in the current file
--
-- blink.cmp also provides get_lsp_capabilities() which we call in lsp.lua
-- to tell every LSP server what completion features Neovim supports.

return {
  "saghen/blink.cmp",
  version = "*", -- use the latest stable release

  -- blink.cmp ships pre-compiled Rust binaries for common platforms.
  -- "cargo build --release" is the fallback if no pre-built binary matches.
  -- Since you have Rust installed, this always works.
  build = "cargo build --release",

  event = { "InsertEnter", "CmdlineEnter" },

  opts = {
    -- ==========================================================================
    -- Keymaps
    -- ==========================================================================
    -- "default" preset:
    --   <C-space>    open / refresh the completion menu
    --   <C-e>        dismiss the menu
    --   <C-y>        accept the selected item
    --   <C-n>/<C-p>  move down/up through the list
    --   <Tab>        next item (or jump to next snippet placeholder)
    --   <S-Tab>      previous item (or jump to previous placeholder)
    keymap = { preset = "default" },

    -- ==========================================================================
    -- Appearance
    -- ==========================================================================
    appearance = {
      -- Use the same highlight groups as nvim-cmp so colorschemes work
      use_nvim_cmp_as_default = true,
      -- "mono" = single character Nerd Font icon per item kind
      nerd_font_variant = "mono",
    },

    -- ==========================================================================
    -- Sources
    -- ==========================================================================
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    -- ==========================================================================
    -- Completion behavior
    -- ==========================================================================
    completion = {
      -- Show a documentation popup next to the highlighted completion item.
      -- Delay keeps it from appearing on every keystroke while you're typing.
      documentation = {
        auto_show          = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
      },

      -- Show a faint preview of the selected item directly in the buffer.
      -- Press <C-y> to accept it.
      ghost_text = { enabled = true },

      -- Completion dropdown appearance
      menu = {
        border = "rounded",
        draw = {
          -- Left column: completion label + description
          -- Right column: kind icon + kind name (Function, Variable, etc.)
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
        },
      },
    },

    -- ==========================================================================
    -- Snippets
    -- ==========================================================================
    -- Use Neovim's built-in snippet engine (no external plugin needed)
    snippets = { preset = "default" },

    -- ==========================================================================
    -- Signature help
    -- ==========================================================================
    -- Shows the function signature (parameter names and types) in a floating
    -- window as you type arguments. Replaces the need for lsp_signature.nvim.
    signature = {
      enabled = true,
      window  = { border = "rounded" },
    },
  },
}
