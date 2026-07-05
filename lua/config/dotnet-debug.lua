-- =============================================================================
-- dotnet-debug.lua — plugin-free "debug nearest test" for C#
-- =============================================================================
-- Why this exists:
--   neotest-dotnet is incompatible with Neovim 0.12 (it calls the old
--   treesitter `iter_matches({all=false})` API, where captures were single
--   nodes; 0.12 makes them arrays, so its discovery crashes). Rather than
--   depend on a broken plugin, C# test debugging goes straight through
--   nvim-dap, using the test platform's own debug hook.
--
-- Flow when you press <leader>td in a C# file:
--   1. Find the test method under the cursor via treesitter.
--   2. Run `dotnet test --filter FullyQualifiedName~<method>` with
--      VSTEST_HOST_DEBUG=1, which builds, starts the test host, and PAUSES it
--      until a debugger attaches (printing its process id).
--   3. Parse that process id and attach the coreclr adapter to it. Your
--      breakpoints then fire.
--
-- Bound to <leader>td in C# buffers (the same key neotest uses for other
-- languages) and exposed as :DotnetDebugNearest.

local M = {}

-- Name of the [Fact]/[Theory] method under the cursor, or nil.
-- Uses the grammar's `name` field (not "first identifier") so methods that
-- return a custom type — e.g. `List<Player> Foo()` — resolve correctly.
local function nearest_test_method()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then return nil end
  while node and node:type() ~= "method_declaration" do
    node = node:parent()
  end
  if not node then return nil end
  local name = node:field("name")[1]
  return name and vim.treesitter.get_node_text(name, 0) or nil
end

-- Nearest directory containing a *.csproj above the current file.
-- `dotnet test` must run from (or be pointed at) the test project.
local function project_dir()
  local found = vim.fs.find(
    function(n) return n:match("%.csproj$") end,
    { upward = true, path = vim.fn.expand("%:p:h") }
  )[1]
  return found and vim.fn.fnamemodify(found, ":h") or vim.fn.getcwd()
end

function M.debug_nearest()
  local method = nearest_test_method()
  if not method then
    vim.notify("No C# test method under the cursor", vim.log.levels.ERROR)
    return
  end

  local dap = require("dap") -- triggers lazy-load of nvim-dap + its coreclr adapter
  local cwd = project_dir()
  local attached = false

  vim.notify(("Building + starting test host for %s ..."):format(method), vim.log.levels.INFO)

  vim.fn.jobstart(
    { "dotnet", "test", "--filter", "FullyQualifiedName~" .. method },
    {
      cwd = cwd,
      env = { VSTEST_HOST_DEBUG = "1" }, -- merged with the parent environment
      on_stdout = function(_, data)
        for _, line in ipairs(data or {}) do
          local pid = line:match("Process Id:%s*(%d+)")
          if pid and not attached then
            attached = true
            vim.schedule(function()
              vim.notify("Attaching debugger to test host (pid " .. pid .. ")", vim.log.levels.INFO)
              dap.run({
                type      = "coreclr",
                request   = "attach",
                name      = "Attach to dotnet test host",
                processId = tonumber(pid),
              })
            end)
          end
        end
      end,
      on_exit = function(_, code)
        if not attached then
          vim.schedule(function()
            vim.notify(
              "dotnet test exited (code " .. code .. ") without pausing for a debugger. "
                .. "Build failure, or no test matched FullyQualifiedName~" .. method .. "?",
              vim.log.levels.WARN
            )
          end)
        end
      end,
    }
  )
end

-- <leader>td in C# buffers → debug the nearest test (mirrors neotest elsewhere).
vim.api.nvim_create_autocmd("FileType", {
  group    = vim.api.nvim_create_augroup("user_dotnet_debug", { clear = true }),
  pattern  = "cs",
  callback = function(ev)
    vim.keymap.set("n", "<leader>td", M.debug_nearest,
      { buffer = ev.buf, desc = "Test: Debug Nearest (C#)" })
  end,
})

vim.api.nvim_create_user_command("DotnetDebugNearest", M.debug_nearest, {})

return M
