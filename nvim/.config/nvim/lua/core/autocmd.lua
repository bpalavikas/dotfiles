local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
autocmd("TextYankPost", {
  desc = "Highlight yanked text",

  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 200,
    })
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  desc = "Remove trailing whitespace",

  pattern = "*",

  callback = function()
    local save = vim.fn.winsaveview()

    vim.cmd([[%s/\s\+$//e]])

    vim.fn.winrestview(save)
  end,
})

-- Restore cursor position when reopening files
autocmd("BufReadPost", {
  desc = "Restore cursor position",

  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Automatically create missing directories on save
autocmd("BufWritePre", {
  desc = "Create missing directories on save",

  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    local dir = vim.fn.fnamemodify(file, ":p:h")

    vim.fn.mkdir(dir, "p")
  end,
})

-- Resize splits automatically when terminal is resized
autocmd("VimResized", {
  desc = "Resize splits on terminal resize",

  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Open help in vertical split
autocmd("FileType", {
  desc = "Open help in vertical split",

  pattern = "help",

  callback = function()
    vim.cmd.wincmd("L")
  end,
})

-- Close some temporary buffers with q
autocmd("FileType", {
  desc = "Close temporary windows with q",

  pattern = {
    "help",
    "man",
    "qf",
    "lspinfo",
    "checkhealth",
    "startuptime",
    "notify",
  },

  callback = function(event)
    vim.bo[event.buf].buflisted = false

    vim.keymap.set(
      "n",
      "q",
      "<cmd>close<CR>",
      {
        buffer = event.buf,
        silent = true,
      }
    )
  end,
})

-- Enable wrapping/spell for markdown and git commits
autocmd("FileType", {
  desc = "Markdown/gitcommit settings",

  pattern = {
    "markdown",
    "gitcommit",
  },

  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.linebreak = true
  end,
})

-- Return to normal mode when leaving terminal
autocmd("TermClose", {
  desc = "Leave terminal insert mode on close",

  callback = function()
    vim.cmd("stopinsert")
  end,
})
