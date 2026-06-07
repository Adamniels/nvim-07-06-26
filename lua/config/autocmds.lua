-- =============================================================================
-- autocmds.lua — autocommands
-- =============================================================================
-- Autocommands run Lua callbacks in response to Neovim events.
-- Each one is placed in its own augroup so it can be safely cleared and
-- re-sourced without creating duplicate listeners.

local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- =============================================================================
-- Highlight on yank
-- =============================================================================
-- Briefly highlights the text you just yanked. Gives visual confirmation
-- of what was copied and how much of it.
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ timeout = 250 })
  end,
})

-- =============================================================================
-- Restore cursor position
-- =============================================================================
-- When you reopen a file, jump back to the line you were on last time.
-- Skips special buffers (git commits, etc.) where line 1 is always correct.
autocmd("BufReadPost", {
  group = augroup("restore_cursor"),
  callback = function(event)
    -- Don't restore for git commits — you always want line 1 there
    local ft = vim.bo[event.buf].filetype
    if ft == "gitcommit" or ft == "gitrebase" then return end

    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- =============================================================================
-- Don't auto-insert comment leaders on new lines
-- =============================================================================
-- Without this, pressing Enter inside a comment continues it on the next line.
-- That's rarely what you want — if you want a new comment line you can use gcc.
-- Must be FileType-scoped (not in options.lua) because many plugins reset
-- formatoptions when they set their own filetype.
autocmd("FileType", {
  group = augroup("no_auto_comment"),
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- =============================================================================
-- Close certain windows with just q
-- =============================================================================
-- Help pages, LSP info, man pages, quickfix etc. normally require :q to close.
-- This makes q close them directly — same single-key experience as most UIs.
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "checkhealth",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", {
      buffer = event.buf,
      silent = true,
      desc   = "Close window",
    })
  end,
})

-- =============================================================================
-- Auto-resize splits on terminal resize
-- =============================================================================
-- When you resize the Kitty window, re-equalize all open splits proportionally.
autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- =============================================================================
-- Detect file changes outside Neovim
-- =============================================================================
-- If a file changes on disk while open (git branch switch, external script, etc.)
-- automatically reload it so you're always editing the current version.
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- =============================================================================
-- Handle `nvim .` (opening a directory)
-- =============================================================================
-- netrw is disabled (we use neo-tree). Without this, opening a directory with
-- `nvim .` or `nvim ~/projects` would leave you in a blank buffer.
-- Instead, cd into the directory and open the file picker.
autocmd("VimEnter", {
  group = augroup("open_dir_with_picker"),
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(data.file)
      -- Schedule so snacks has fully initialized before we call it
      vim.schedule(function()
        Snacks.picker.files()
      end)
    end
  end,
})
