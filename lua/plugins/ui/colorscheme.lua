-- =============================================================================
-- colorscheme.lua — VSCode Dark+ (Mofiqul/vscode.nvim)
-- =============================================================================
-- lazy = false and priority = 1000 tell lazy.nvim to load this plugin first,
-- before everything else. Colorschemes must load early or you get a flash of
-- the default theme before the real one kicks in.

return {
	"Mofiqul/vscode.nvim",
	lazy = false,
	priority = 1000,

	opts = {
		style = "dark", -- "dark" is VSCode's Dark+ (#1e1e1e background); "light" for light mode
		transparent = true, -- let the terminal background show through
		italic_comments = true,
		underline_links = true,
		terminal_colors = true, -- apply theme to Neovim's built-in terminal too

		-- Tweak individual highlight groups if needed later.
		-- Example: make line numbers less prominent.
		group_overrides = {
			LineNr = { fg = "#5a5a5a" },
			CursorLineNr = { fg = "#d7ba7d", bold = true }, -- VSCode-ish gold accent
		},
	},

	config = function(_, opts)
		require("vscode").setup(opts)
		vim.cmd.colorscheme("vscode")
	end,
}
