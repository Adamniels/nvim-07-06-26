-- =============================================================================
-- neo-tree.lua — sidebar file explorer
-- =============================================================================
-- neo-tree is a persistent sidebar showing your project's file tree.
-- It integrates with git (shows changed/added/deleted files), LSP diagnostics,
-- and lets you manage files (create, rename, move, delete) from inside Neovim.
--
-- Keymaps (inside the neo-tree window):
--   l / Enter = open file or expand directory
--   h         = close (collapse) directory
--   a         = add file (append / for directory)
--   d         = delete
--   r         = rename
--   m         = move
--   c         = copy
--   p         = paste
--   q         = close neo-tree
--   ?         = show all keymaps

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},

	-- Lazy-load on these commands and keymaps.
	-- lazy.nvim will load neo-tree automatically when you press <leader>e.
	cmd = { "Neotree" },
	keys = {
		{ "<F13>f", "<cmd>Neotree toggle<CR>", desc = "Toggle Explorer" },
		{ "<F13>t", "<cmd>Neotree reveal<CR>", desc = "Reveal File in Explorer" },
	},

	opts = {
		-- Close neo-tree automatically when it is the last window open.
		-- Without this you can get stuck in a neo-tree-only window.
		close_if_last_window = true,

		-- =========================================================================
		-- Popup window border style
		-- =========================================================================
		popup_border_style = "rounded",

		-- =========================================================================
		-- Filesystem source
		-- =========================================================================
		filesystem = {
			-- Don't change the global cwd when you navigate into a directory.
			-- This keeps the rest of Neovim (picker, grep, LSP) anchored to your
			-- original project root.
			bind_to_cwd = false,

			-- Automatically expand and highlight the current file in the tree
			-- when you switch buffers.
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},

			-- Watch for file changes on disk (new files, deletions, renames)
			-- and update the tree automatically without needing to refresh.
			use_libuv_file_watcher = true,

			filtered_items = {
				visible = false,
				hide_dotfiles = false, -- show .env, .gitignore, .github etc.
				hide_gitignored = false, -- show gitignored files too (node_modules etc.)
				hide_hidden = false, -- show macOS/Windows hidden files
			},
		},

		-- =========================================================================
		-- Window appearance
		-- =========================================================================
		window = {
			position = "left",
			width = 35,

			mappings = {
				-- Prevent neo-tree from stealing <Space> (our leader key)
				["<space>"] = "none",

				-- vi-style navigation inside the tree
				["l"] = "open",
				["h"] = "close_node",

				-- Open in splits (mirrors our global split keymaps)
				["sv"] = "open_vsplit",
				["sh"] = "open_split",
			},
		},

		-- =========================================================================
		-- Icons and component display
		-- =========================================================================
		default_component_configs = {
			indent = {
				with_expanders = true,
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},

			icon = {
				folder_closed = "",
				folder_open = "",
				folder_empty = "󰜌",
			},

			modified = {
				symbol = "●",
				highlight = "NeoTreeModified",
			},

			git_status = {
				symbols = {
					added = "",
					modified = "",
					deleted = "✖",
					renamed = "󰁕",
					untracked = "",
					ignored = "",
					unstaged = "󰄱",
					staged = "",
					conflict = "",
				},
			},
		},

		-- =========================================================================
		-- Sources — what neo-tree can show (switch with the keymaps below)
		-- =========================================================================
		sources = { "filesystem", "buffers", "git_status" },

		-- Don't show the source selector bar at the top of neo-tree —
		-- it takes space and we can switch sources with keymaps.
		source_selector = { winbar = false },
	},
}
