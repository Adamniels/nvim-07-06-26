-- =============================================================================
-- dap-ui.lua — debugging UI panels
-- =============================================================================
-- nvim-dap-ui opens a set of panels when you start debugging:
--
--   LEFT SIDEBAR          BOTTOM BAR
--   ┌──────────────┐      ┌─────────────────────────────────┐
--   │ Variables    │      │ REPL / Console                  │
--   │ Watch        │      │ (evaluate expressions, see logs)│
--   │ Call Stack   │      └─────────────────────────────────┘
--   │ Breakpoints  │
--   └──────────────┘
--
-- The panels open automatically when a debug session starts and close when
-- the session ends. Toggle them manually with <leader>du.
--
-- nvim-dap-virtual-text shows variable values inline next to the code,
-- so you can see state without switching to the Variables panel.

return {

  -- ==========================================================================
  -- nvim-dap-ui
  -- ==========================================================================
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio", -- required by nvim-dap-ui for its async runtime
    },

    keys = {
      {
        "<leader>du",
        function() require("dapui").toggle() end,
        desc = "Debug: Toggle UI",
      },
      {
        "<leader>de",
        function()
          -- Evaluate the expression under the cursor or selected text
          require("dapui").eval(nil, { enter = true })
        end,
        mode = { "n", "v" },
        desc = "Debug: Evaluate Expression",
      },
    },

    config = function()
      local dap    = require("dap")
      local dapui  = require("dapui")

      dapui.setup({
        icons = {
          expanded     = "",
          collapsed    = "",
          current_frame = "",
        },

        -- Controls (the small toolbar shown in the UI)
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause        = "",
            play         = "",
            step_into    = "",
            step_over    = "",
            step_out     = "",
            step_back    = "",
            run_last     = "",
            terminate    = "",
            disconnect   = "",
          },
        },

        -- Panel layout
        layouts = {
          -- Left sidebar: variables, watch expressions, call stack, breakpoints
          {
            elements = {
              { id = "scopes",      size = 0.35 }, -- local / global variables
              { id = "watches",     size = 0.15 }, -- user-defined watch expressions
              { id = "stacks",      size = 0.35 }, -- call stack
              { id = "breakpoints", size = 0.15 }, -- all breakpoints
            },
            position = "left",
            size     = 40,
          },
          -- Bottom: REPL and program output console
          {
            elements = {
              { id = "repl",    size = 0.5 }, -- interactive expression evaluator
              { id = "console", size = 0.5 }, -- program stdout / stderr
            },
            position = "bottom",
            size     = 15,
          },
        },

        floating = {
          border   = "rounded",
          mappings = { close = { "q", "<Esc>" } },
        },
      })

      -- ========================================================================
      -- Auto open / close UI with the debug session
      -- ========================================================================
      -- Open the panels when a session starts (launch or attach)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      -- Close the panels when the session ends
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- ==========================================================================
  -- nvim-dap-virtual-text
  -- ==========================================================================
  -- Shows variable values as virtual text next to the code line where they
  -- are defined or last changed. Very useful for inspecting state at a glance.
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      commented          = true,  -- show virtual text as a comment (greyed out)
      highlight_changed_variables = true,
      highlight_new_as_changed    = true,
      show_stop_reason   = true,  -- show why execution stopped (breakpoint, exception, etc.)
      virt_text_pos      = "eol", -- at end of line
    },
  },
}
