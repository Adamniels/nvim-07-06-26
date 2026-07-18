-- =============================================================================
-- options.lua — core Neovim settings
-- =============================================================================
-- All settings use vim.opt (the modern Lua interface to vim options).
-- No plugin dependencies — this file loads before any plugin.

-- =============================================================================
-- PATH — make Homebrew tools available to Neovim subprocesses
-- =============================================================================
-- On macOS, Neovim may not inherit the full shell PATH (depends on how it's
-- launched). This ensures Homebrew-installed tools like tree-sitter, ripgrep,
-- fd, and language servers are always findable by Neovim and its plugins.
do
  local extra = {
    "/opt/homebrew/bin",                  -- standard Homebrew binaries
    "/opt/homebrew/opt/tree-sitter/bin",  -- tree-sitter (not symlinked by default)
  }
  for _, p in ipairs(extra) do
    if not vim.env.PATH:find(p, 1, true) then
      vim.env.PATH = p .. ":" .. vim.env.PATH
    end
  end
end

-- Disable netrw — we use neo-tree instead.
-- These MUST be set before any plugin loads, which is why they're here
-- in options.lua rather than in a plugin file.
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

-- =============================================================================
-- Line numbers
-- =============================================================================
opt.number = true           -- Show absolute line number on current line
opt.relativenumber = true   -- Show relative numbers on all other lines
                            -- Combined: current line shows absolute, others show distance

-- =============================================================================
-- Tabs & indentation
-- =============================================================================
opt.tabstop = 2             -- A tab character is 2 spaces wide visually
opt.shiftwidth = 2          -- >> and << indent by 2 spaces
opt.expandtab = true        -- Insert spaces instead of tab characters
opt.smartindent = true      -- Auto-indent new lines based on language syntax

-- =============================================================================
-- Appearance
-- =============================================================================
opt.termguicolors = true    -- Enable 24-bit RGB colors (required by most themes)
opt.signcolumn = "yes"      -- Always show the sign column (git, diagnostics icons)
                            -- "yes" prevents the editor from jumping when signs appear
opt.cursorline = true       -- Highlight the line the cursor is on
opt.scrolloff = 8           -- Keep 8 lines visible above/below the cursor when scrolling
opt.sidescrolloff = 8       -- Keep 8 columns visible left/right when scrolling horizontally
opt.wrap = false            -- Don't wrap long lines — scroll horizontally instead
opt.colorcolumn = "120"     -- Show a subtle vertical line at column 120
opt.showmode = false        -- Don't show "-- INSERT --" etc. — lualine handles this
opt.pumheight = 10          -- Max 10 items in completion popup before it scrolls
opt.fillchars:append({ eob = " " }) -- Hide the "~" filler glyphs on empty lines past EOF
                            -- (with transparent=true they don't blend with the terminal bg)

-- =============================================================================
-- Search
-- =============================================================================
opt.ignorecase = true       -- Case-insensitive search by default
opt.smartcase = true        -- ...but case-sensitive if you type an uppercase letter
opt.hlsearch = true         -- Highlight all search matches
opt.incsearch = true        -- Show matches incrementally as you type

-- =============================================================================
-- Splits
-- =============================================================================
opt.splitbelow = true       -- Horizontal splits open below the current window
opt.splitright = true       -- Vertical splits open to the right of the current window

-- =============================================================================
-- Files & persistence
-- =============================================================================
opt.undofile = true         -- Persist undo history across sessions
                            -- Stored in vim.fn.stdpath("state")/undo/
opt.backup = false          -- Don't create backup files
opt.swapfile = false        -- Don't create swap files (use undofile instead)
opt.fileencoding = "utf-8"  -- Default file encoding

-- =============================================================================
-- Performance
-- =============================================================================
opt.updatetime = 200        -- Faster CursorHold events (used by LSP hover, gitsigns)
                            -- Default is 4000ms which feels sluggish
opt.timeoutlen = 300        -- Time to wait for a key sequence to complete (ms)
                            -- Affects which-key popup delay

-- =============================================================================
-- Completion
-- =============================================================================
-- These are fallback options — blink.cmp overrides completion behavior.
opt.completeopt = "menu,menuone,noselect"

-- =============================================================================
-- Clipboard
-- =============================================================================
-- Use the system clipboard for all yank/paste operations.
-- On macOS this uses pbcopy/pbpaste automatically.
opt.clipboard = "unnamedplus"

-- =============================================================================
-- Mouse
-- =============================================================================
opt.mouse = "a"             -- Enable mouse in all modes
                            -- Useful for resizing splits and clicking links in hover docs

-- =============================================================================
-- Misc
-- =============================================================================
opt.conceallevel = 0        -- Don't hide/replace any characters
                            -- Some plugins (noice, markdown) change this per-buffer
opt.isfname:append("@-@")  -- Allow @ in file names (useful for TypeScript paths like @/components)
opt.splitkeep = "screen"   -- Keep text stable when opening/closing splits (Neovim 0.9+)

-- Suppress "match 1 of N" and similar completion messages in the command area
opt.shortmess:append("c")
