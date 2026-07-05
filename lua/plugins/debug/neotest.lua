-- =============================================================================
-- neotest.lua — unified test running + test debugging across languages
-- =============================================================================
-- neotest is a language-agnostic test runner. You add one adapter per language
-- and get the SAME keymaps everywhere:
--
--   <leader>tr  run the test under the cursor
--   <leader>td  DEBUG the test under the cursor  (drops into nvim-dap)
--   <leader>tR  run every test in the current file
--   <leader>ts  toggle the test summary sidebar
--   <leader>to  show output for the last-run test
--   <leader>tw  toggle watch mode (re-run on save)
--
-- The key win for debugging: <leader>td launches the test host with the
-- debugger already attached and stops at your breakpoints. No dll paths,
-- no args, no PID hunting. Works identically for C#, Python, JS/TS, Rust.
--
-- Adapters here match the languages configured in dap.lua. Each adapter uses
-- the SAME dap adapters (debugpy, netcoredbg, ...) under the hood, so anything
-- that debugs via <F5> also debugs via <leader>td.

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap", -- so <leader>td can use the dap strategy

    -- Language adapters (one per language you test in)
    -- NOTE: no neotest-dotnet — it's incompatible with Neovim 0.12 (uses the
    -- removed treesitter iter_matches `{all=false}` API and crashes on discovery).
    -- C# test debugging is handled plugin-free in config/dotnet-debug.lua instead.
    "nvim-neotest/neotest-python", -- Python (pytest / unittest)
    "nvim-neotest/neotest-jest",   -- JS / TS (Jest)
    "rouge8/neotest-rust",         -- Rust (needs cargo-nextest installed)
  },

  keys = {
    { "<leader>tr", function() require("neotest").run.run() end,                    desc = "Test: Run Nearest" },
    { "<leader>tR", function() require("neotest").run.run(vim.fn.expand("%")) end,  desc = "Test: Run File" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: Debug Nearest" },
    { "<leader>ts", function() require("neotest").summary.toggle() end,             desc = "Test: Toggle Summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test: Show Output" },
    { "<leader>tw", function() require("neotest").watch.toggle() end,               desc = "Test: Toggle Watch" },
    { "<leader>tS", function() require("neotest").run.stop() end,                   desc = "Test: Stop" },
  },

  config = function()
    require("neotest").setup({
      adapters = {
        -- justMyCode = false lets you step into library/framework code too
        require("neotest-python")({ dap = { justMyCode = false } }),
        require("neotest-jest"),
        require("neotest-rust"),
      },
    })
  end,
}
