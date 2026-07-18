-- =============================================================================
-- dap.lua — Debug Adapter Protocol core
-- =============================================================================
-- nvim-dap is a DAP client for Neovim. It communicates with language-specific
-- debug servers (adapters) using Microsoft's Debug Adapter Protocol.
--
-- ARCHITECTURE
--   Neovim (nvim-dap) ←→ Debug Adapter ←→ Debugger ←→ Your program
--
-- Each language needs two things configured:
--   adapter     — how to launch the debug server for that language
--   configuration — what program to run and with what arguments
--
-- mason-nvim-dap installs the adapters automatically via Mason.
--
-- KEYMAPS
--   <F5>          continue / start debugging
--   <F10>         step over (next line, don't enter function calls)
--   <F11>         step into (enter the function call)
--   <F12>         step out  (finish current function, return to caller)
--   <leader>db    toggle breakpoint
--   <leader>dB    conditional breakpoint (break only if expression is true)
--   <leader>dl    run last debug session again
--   <leader>dr    open REPL (evaluate expressions while paused)
--   <leader>du    toggle debug UI panels

return {

  -- ==========================================================================
  -- nvim-dap — DAP client
  -- ==========================================================================
  {
    "mfussenegger/nvim-dap",

    -- Load only when actually debugging (keeps startup fast)
    keys = {
      { "<F5>",       desc = "Debug: Continue" },
      { "<F10>",      desc = "Debug: Step Over" },
      { "<F11>",      desc = "Debug: Step Into" },
      { "<F12>",      desc = "Debug: Step Out" },
      { "<leader>db", desc = "Debug: Toggle Breakpoint" },
      { "<leader>dB", desc = "Debug: Conditional Breakpoint" },
      { "<leader>dl", desc = "Debug: Run Last" },
      { "<leader>dr", desc = "Debug: Open REPL" },
    },

    config = function()
      local dap = require("dap")

      -- Sign column icons for breakpoints and the current execution line
      vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DapBreakpoint",        linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected",  { text = "✗", texthl = "DapBreakpointRejected",  linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DapStopped",             linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define("DapLogPoint",            { text = "◎", texthl = "DapLogPoint",            linehl = "", numhl = "" })

      -- Helper: resolve a Mason package install path at runtime.
      -- This is safer than hardcoding paths since Mason controls the location.
      local function mason_path(package_name, ...)
        local ok, registry = pcall(require, "mason-registry")
        if not ok then return nil end
        local ok2, pkg = pcall(registry.get_package, package_name)
        if not ok2 then return nil end
        local parts = { pkg:get_install_path(), ... }
        return table.concat(parts, "/")
      end

      -- ========================================================================
      -- Python — debugpy
      -- ========================================================================
      -- Install: auto-installed by mason-nvim-dap (see below)
      dap.adapters.python = {
        type    = "executable",
        command = mason_path("debugpy", "venv/bin/python") or "python3",
        args    = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type    = "python",
          request = "launch",
          name    = "Launch file",
          program = "${file}",
          -- Use the active virtual environment's python if available
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then return venv .. "/bin/python" end
            return vim.fn.exepath("python3") or "python"
          end,
        },
        {
          type    = "python",
          request = "launch",
          name    = "Launch with args",
          program = "${file}",
          args    = function()
            local input = vim.fn.input("Args: ")
            return vim.split(input, " ", { plain = true, trimempty = true })
          end,
          pythonPath = function()
            return vim.fn.exepath("python3") or "python"
          end,
        },
      }

      -- ========================================================================
      -- TypeScript / JavaScript — js-debug-adapter
      -- ========================================================================
      -- Works for Node.js programs and can attach to Chrome/Edge for browser debugging.
      -- Install: auto-installed by mason-nvim-dap (see below)
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args    = {
            mason_path("js-debug-adapter", "js-debug/src/dapDebugServer.js") or "",
            "${port}",
          },
        },
      }

      local js_config = {
        {
          type    = "pwa-node",
          request = "launch",
          name    = "Launch Node file",
          program = "${file}",
          cwd     = "${workspaceFolder}",
        },
        {
          type    = "pwa-node",
          request = "attach",
          name    = "Attach to Node process",
          processId = require("dap.utils").pick_process,
          cwd     = "${workspaceFolder}",
        },
      }

      dap.configurations.typescript       = js_config
      dap.configurations.javascript       = js_config
      dap.configurations.typescriptreact  = js_config
      dap.configurations.javascriptreact  = js_config

      -- ========================================================================
      -- C# — netcoredbg
      -- ========================================================================
      -- Install: auto-installed by mason-nvim-dap (see below)
      -- You need to build your project first: dotnet build
      -- Prefer the hand-installed native build over Mason's.
      -- Mason ships an x86_64 netcoredbg 3.1.3, which (a) can't attach to arm64
      -- .NET processes on Apple Silicon and (b) predates .NET 10 — both surface
      -- as "Failed command 'configurationDone' : 0x80131c3c". The arm64 3.2.0
      -- build from Samsung/netcoredbg releases fixes both.
      -- Install/update: run scripts/install-netcoredbg.sh from the repo root.
      local netcoredbg_native = vim.fn.expand("~/.local/share/netcoredbg/netcoredbg/netcoredbg")
      dap.adapters.coreclr = {
        type    = "executable",
        command = (vim.fn.executable(netcoredbg_native) == 1) and netcoredbg_native
                  or mason_path("netcoredbg", "netcoredbg") or "netcoredbg",
        args    = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type    = "coreclr",
          request = "launch",
          name    = "Launch .NET app",
          -- Prompts you to choose the compiled .dll — build first with `dotnet build`.
          -- Launch the executable project's dll (OutputType=Exe), not a library dll.
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd     = "${workspaceFolder}",
        },
        {
          type    = "coreclr",
          request = "launch",
          name    = "Launch .NET app with args",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
          end,
          args    = function()
            local input = vim.fn.input("Args: ")
            return vim.split(input, " ", { plain = true, trimempty = true })
          end,
          cwd     = "${workspaceFolder}",
        },
        {
          type    = "coreclr",
          request = "attach",
          name    = "Attach to .NET process",
          processId = require("dap.utils").pick_process,
        },
      }

      -- ========================================================================
      -- Rust — codelldb
      -- ========================================================================
      -- codelldb is LLDB-based and handles Rust's types (enums, vecs, etc.) well.
      -- Install: auto-installed by mason-nvim-dap (see below)
      -- Build your project first: cargo build
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = mason_path("codelldb", "extension/adapter/codelldb") or "codelldb",
          args    = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          type    = "codelldb",
          request = "launch",
          name    = "Launch Rust binary",
          -- Prompts you to choose the compiled binary — build first with `cargo build`
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd          = "${workspaceFolder}",
          stopOnEntry  = false,
        },
      }

      -- ========================================================================
      -- Keymaps
      -- ========================================================================
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = desc })
      end

      -- Execution control (function keys for muscle memory from other IDEs)
      map("<F5>",  dap.continue,          "Debug: Continue")
      map("<F10>", dap.step_over,         "Debug: Step Over")
      map("<F11>", dap.step_into,         "Debug: Step Into")
      map("<F12>", dap.step_out,          "Debug: Step Out")

      -- Breakpoints
      map("<leader>db", dap.toggle_breakpoint, "Debug: Toggle Breakpoint")
      map("<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, "Debug: Conditional Breakpoint")

      -- Session
      map("<leader>dl", dap.run_last,     "Debug: Run Last")
      map("<leader>dr", dap.repl.open,    "Debug: Open REPL")
      map("<leader>dx", dap.terminate,    "Debug: Terminate")

      -- ========================================================================
      -- Project-local launch configs (.vscode/launch.json)
      -- ========================================================================
      -- If the project has a .vscode/launch.json, its configurations show up in
      -- the <F5> picker automatically — no need to retype dll paths or args each
      -- session. This is the portable, per-project way to launch an app: the
      -- same file works in VS Code, and it lives in the repo.
      --
      -- The map below tells dap which VS Code "type" applies to which filetypes.
      local ok_vscode, vscode = pcall(require, "dap.ext.vscode")
      if ok_vscode then
        local load_launchjs = function()
          vscode.load_launchjs(nil, {
            coreclr     = { "cs", "fsharp" },
            ["pwa-node"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
            python      = { "python" },
            codelldb    = { "rust", "c", "cpp" },
          })
        end
        load_launchjs()
        -- Reload when you change directory (e.g. open a different project)
        vim.api.nvim_create_autocmd("DirChanged", { callback = load_launchjs })
        map("<leader>dc", load_launchjs, "Debug: Reload launch.json")
      end
    end,
  },

  -- ==========================================================================
  -- mason-nvim-dap — auto-install debug adapters
  -- ==========================================================================
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      -- These adapters are downloaded and installed automatically.
      -- Names here are mason-nvim-dap handler names (not Mason package names).
      ensure_installed = {
        "python",   -- debugpy
        "js",       -- js-debug-adapter (TypeScript + JavaScript)
        "coreclr",  -- netcoredbg (C#)
        "codelldb", -- codelldb (Rust)
      },
      -- Don't auto-configure adapters — we do it manually above so we have
      -- full control over each adapter's settings.
      -- NOTE: an empty table is NOT enough. mason-nvim-dap falls back to its
      -- default_setup for every installed adapter, which would re-register
      -- dap.adapters.coreclr to Mason's (x86_64, outdated) netcoredbg and
      -- clobber our native arm64 override. A no-op handler for coreclr tells
      -- mason-nvim-dap to leave it alone.
      handlers = {
        coreclr = function() end,
      },
    },
  },
}
