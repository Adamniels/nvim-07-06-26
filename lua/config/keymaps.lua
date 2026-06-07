-- =============================================================================
-- keymaps.lua — non-plugin keymaps
-- =============================================================================
-- Only keymaps that don't depend on any plugin go here.
-- Plugin keymaps are defined inside each plugin's config file so that they
-- are only registered when the plugin is actually loaded.

local map = vim.keymap.set

-- =============================================================================
-- Motion improvements
-- =============================================================================

-- Better j/k on wrapped lines.
-- Without this, j/k jump by logical lines — so a very long line counts as one
-- jump even if it wraps across 5 visual rows. With this, they move by visual
-- row when count is 0 (no prefix number), and by logical line when prefixed
-- (so 5j still jumps 5 logical lines for relative number jumping).
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Keep cursor vertically centered when jumping through search results
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- =============================================================================
-- Search
-- =============================================================================

-- Clear search highlight with Escape in normal mode.
-- The highlight stays visible until you do this or start a new search.
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- =============================================================================
-- File operations
-- =============================================================================

map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>quitall<CR>", { desc = "Quit all" })

-- =============================================================================
-- Window / split navigation
-- =============================================================================

-- Move focus between splits with Ctrl + hjkl.
-- Works the same as <C-w>h/j/k/l but with one less keypress.
map("n", "<C-h>", "<C-w>h", { desc = "Focus left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right split" })

-- Split management
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<CR>",  { desc = "Split horizontal" })
map("n", "<leader>sd", "<cmd>close<CR>",  { desc = "Close split" })
map("n", "<leader>se", "<C-w>=",          { desc = "Equalize splits" })

-- =============================================================================
-- Buffer navigation
-- =============================================================================

-- Shift+h/l to move between buffers — mirrors how you'd move between tabs in VSCode.
-- The bufferline plugin also lets you click tabs, but keyboard is faster.
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })

-- =============================================================================
-- Visual mode improvements
-- =============================================================================

-- Move selected lines up/down and re-indent automatically.
-- In VSCode this is Alt+Up/Down. Here it's J/K in visual mode.
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up",   silent = true })

-- Stay in visual mode after indenting.
-- Without this, < and > in visual mode drop you back to normal mode so you
-- have to re-select every time you want to indent multiple levels.
map("v", "<", "<gv", { desc = "Indent left (stay in visual)" })
map("v", ">", ">gv", { desc = "Indent right (stay in visual)" })

-- Don't lose clipboard content when pasting over a visual selection.
-- Default Neovim behaviour replaces your clipboard with the deleted text.
-- This keeps your original yank intact.
map("v", "p", '"_dP', { desc = "Paste without losing clipboard" })

-- =============================================================================
-- Miscellaneous
-- =============================================================================

-- Join lines without moving cursor (default J moves cursor to the joined position)
map("n", "J", "mzJ`z", { desc = "Join lines (cursor stays)" })
