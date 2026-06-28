-- =============================================================================
-- avante.lua — AI coding assistant (Claude)
-- =============================================================================
-- avante.nvim gives you a Cursor-style AI panel inside Neovim.
-- It talks to Claude via the Anthropic API.
--
-- SETUP REQUIRED
-- Add your Anthropic API key to ~/.zshrc:
--   export ANTHROPIC_API_KEY="sk-ant-..."
-- Then reload: source ~/.zshrc
--
-- KEYMAPS
--   <leader>aa   open / toggle the AI sidebar
--   <leader>ae   ask AI to edit the selected code (visual mode)
--   <leader>ar   refresh / retry the last request
--   <leader>af   focus the AI sidebar
--
-- INSIDE THE SIDEBAR
--   Type your question or instruction and press <CR> (normal) or <C-s> (insert)
--   The AI will read your current file as context automatically.
--
-- APPLYING SUGGESTIONS
--   co   accept our version (keep original)
--   ct   accept their version (apply AI suggestion)
--   cb   keep both
--   ]x   jump to next diff
--   [x   jump to previous diff

return {
	"yetone/avante.nvim",

	-- Always use the latest — avante moves fast and older versions break
	version = false,
	event = "VeryLazy",

	-- avante has a Rust component that needs compiling.
	-- "make" runs the Makefile which handles this automatically.
	build = "make",

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",

		-- Renders markdown properly in the avante chat panel
		-- (code blocks, bold, headings, etc.)
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},

		-- Lets you paste images into the chat (drag-and-drop or clipboard)
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = { insert_mode = true },
					use_absolute_path = true,
				},
			},
		},
	},

	opts = {
		-- =========================================================================
		-- Provider
		-- =========================================================================
		provider = "claude",

		-- Provider-specific settings live under `providers` in the new API.
		-- timeout, temperature, and max_tokens go into extra_request_body.
		providers = {
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-sonnet-4-6",
				timeout = 30000, -- ms before giving up on a request (provider-level, NOT request body)
				extra_request_body = {
					temperature = 0, -- 0 = deterministic, precise answers
					max_tokens = 8096,
				},
			},
		},

		-- =========================================================================
		-- Behaviour
		-- =========================================================================
		behaviour = {
			-- Show inline (ghost-text) suggestions as you type, Copilot-style.
			-- Accept / cycle them with the `suggestion` mappings below.
			auto_suggestions = true,

			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			-- Don't apply diffs automatically — let you review first
			auto_apply_diff_after_generation = false,
		},

		-- =========================================================================
		-- Sidebar window
		-- =========================================================================
		windows = {
			position = "right",
			wrap = true,
			width = 35, -- percentage of editor width
			sidebar_header = {
				enabled = true,
				align = "center",
				rounded = true,
			},
			input = {
				prefix = "> ",
				height = 8,
			},
		},

		-- =========================================================================
		-- Diff view
		-- =========================================================================
		diff = {
			autojump = true, -- jump to first diff automatically
			list_opener = "copen",
		},

		highlights = {
			diff = {
				current = "DiffText",
				incoming = "DiffAdd",
			},
		},

		-- =========================================================================
		-- Keymaps
		-- =========================================================================
		mappings = {
			-- Inline ghost-text suggestions (auto_suggestions = true)
			-- Ctrl+letter only — layout-independent, so they work on the Swedish
			-- Mac layout where [ ] { } and Alt/Option are needed for typing.
			suggestion = {
				accept = "<C-l>", -- Ctrl-l : accept the suggestion
				next = "<C-f>", -- Ctrl-f : next suggestion (forward)
				prev = "<C-b>", -- Ctrl-b : previous suggestion (back)
				dismiss = "<C-g>", -- Ctrl-g : dismiss
			},

			-- Diff resolution (when AI proposes changes)
			diff = {
				ours = "co", -- keep our version
				theirs = "ct", -- accept AI version
				all_theirs = "ca",
				both = "cb", -- keep both
				cursor = "cc",
				next = "]x",
				prev = "[x",
			},

			-- Jump between AI-suggested sections
			jump = {
				next = "]]",
				prev = "[[",
			},

			-- Submit a message to the AI
			submit = {
				normal = "<CR>", -- in normal mode inside the chat input
				insert = "<C-s>", -- in insert mode inside the chat input
			},

			sidebar = {
				apply_all = "A",
				apply_cursor = "a",
				switch_windows = "<Tab>",
			},
		},
	},
}
