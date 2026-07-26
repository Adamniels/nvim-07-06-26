-- =============================================================================
-- commands.lua — user commands
-- =============================================================================
-- Custom `:Commands` that don't fit keymaps or autocmds.

-- =============================================================================
-- :Md — open a markdown file in QuickMD
-- =============================================================================
-- Shells out to the QuickMD.app (macOS) markdown previewer instead of
-- rendering inline. With no argument, previews the current buffer's file.
vim.api.nvim_create_user_command("Md", function(opts)
  local path = opts.args ~= "" and opts.args or vim.fn.expand("%:p")
  path = vim.fn.fnamemodify(vim.fn.expand(path), ":p")

  if vim.fn.filereadable(path) == 0 then
    vim.notify("Md: file not found — " .. path, vim.log.levels.ERROR)
    return
  end

  vim.system({ "open", "-a", "QuickMD", path }, {}, function(obj)
    if obj.code ~= 0 then
      vim.schedule(function()
        vim.notify("Md: QuickMD exited with code " .. obj.code, vim.log.levels.ERROR)
      end)
    end
  end)
end, {
  nargs = "?",
  complete = "file",
  desc = "Open a markdown file in QuickMD",
})
