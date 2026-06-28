-- =============================================================================
-- colorscheme.lua — TokyoNight Night
-- =============================================================================
-- lazy = false and priority = 1000 tell lazy.nvim to load this plugin first,
-- before everything else. Colorschemes must load early or you get a flash of
-- the default theme before the real one kicks in.

return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,

	opts = {
		style = "night", -- "night" is the darkest variant (#1a1b26 background)
		light_style = "day", -- used if you ever switch to light mode
		transparent = true, -- let the terminal background show through
		terminal_colors = true, -- apply theme to Neovim's built-in terminal too

		styles = {
			comments = { italic = true },
			keywords = { italic = false }, -- no italic keywords — personal preference, change if you like
			functions = {},
			variables = {},
			sidebars = "transparent", -- neo-tree, telescope, etc. stay transparent too
			floats = "transparent", -- floating windows (hover docs, completion) stay transparent
		},

		-- Tweak individual highlight groups if needed later.
		-- Example: make line numbers less prominent
		on_highlights = function(hl, c)
			hl.LineNr = { fg = c.dark5 }
			hl.CursorLineNr = { fg = c.orange, bold = true }
		end,
	},

	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd.colorscheme("tokyonight-night")
	end,
}
