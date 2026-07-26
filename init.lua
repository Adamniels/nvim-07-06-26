-- =============================================================================
-- init.lua — entry point
-- =============================================================================
-- Load order matters:
--   1. Leader key (must be set before any plugin or keymap references it)
--   2. Core vim options
--   3. Non-plugin keymaps
--   4. Autocommands
--   5. Plugin manager (lazy.nvim) + all plugins

-- Leader key — set BEFORE lazy loads anything so plugin keymaps pick it up
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core config (no plugin dependencies)
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
require("config.dotnet-debug") -- plugin-free <leader>td for C# (see the file for why)

-- =============================================================================
-- Bootstrap lazy.nvim
-- =============================================================================
-- lazy.nvim installs itself on first launch. After that it just uses the
-- existing install. You never need to manually install it.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- Load plugins
-- =============================================================================
-- Each { import = "plugins.X" } tells lazy.nvim to scan lua/plugins/X/*.lua
-- and treat every file it finds as a plugin spec.
-- When you add a new category, add one line here. That's it.
require("lazy").setup({
	{ import = "plugins.ui" },
	{ import = "plugins.editor" },
	{ import = "plugins.lsp" },
	{ import = "plugins.debug" },
	{ import = "plugins.ai" },
}, {
	-- Don't notify when config files change (reduces noise while editing config)
	change_detection = { notify = false },

	-- Disable built-in Neovim plugins we don't use
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
