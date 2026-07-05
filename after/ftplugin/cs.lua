-- =============================================================================
-- after/ftplugin/cs.lua — C#-specific buffer overrides
-- =============================================================================
-- Neovim sources this automatically for every C# buffer, after the built-in
-- ftplugin/cs.vim has run. It's the idiomatic place for buffer-local overrides.
--
-- Why: the global default is 2-space indent (see lua/config/options.lua), but
-- csharpier — the C# formatter (see lua/plugins/lsp/conform.lua) — reformats to
-- 4 spaces on save. csharpier is the source of truth; here we make the live
-- indenter (cs.vim's cindent + shiftwidth) agree with it so typing at 2 spaces
-- doesn't jump to 4 the moment you save. 4 spaces is also the .NET/Unity norm.

vim.bo.shiftwidth  = 4   -- one indent level = 4 spaces
vim.bo.tabstop     = 4   -- a tab renders as 4 columns
vim.bo.softtabstop = 4   -- <Tab>/<BS> in insert mode move by 4
-- expandtab is inherited from the global default (spaces, not tabs).
