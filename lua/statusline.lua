-- Statusline (lualine) + git blame. The statusline shows mode / filename /
-- diagnostics / diff / file info / location; the tabline lists buffers and tabs.
local lualine = require 'lualine'
local git_blame = require 'gitblame'

-- Show the blame in the statusline rather than as inline virtual text. Set
-- before git-blame.nvim initializes so it picks up the preference on load.
vim.g.gitblame_display_virtual_text = 0
-- Blame: author, relative time, and the commit summary.
vim.g.gitblame_message_template = '<author> • <date> • <summary>'
vim.g.gitblame_date_format = '%r'

-- Diagnostic counts shown in the statusline, sourced from the native LSP client.
local diagnostics = {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
}

lualine.setup {
  options = {
    theme = 'auto', -- follows the active colorscheme (ansi)
    disabled_filetypes = { 'NvimTree' } -- no statusline inside the file tree
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'filename', path = 1 } -- path = 1: show path relative to cwd
    },
    lualine_c = {
      diagnostics,
      -- git blame for the current line, sourced from git-blame.nvim
      { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
    },
    lualine_x = { 'diff' },             -- git add/change/delete counts
    lualine_y = { 'encoding', 'filetype' },
    lualine_z = { 'location' }          -- line:col
  },
  tabline = {
    lualine_b = { 'buffers' }, -- open buffers on the left
    lualine_z = { 'tabs' }     -- tab pages on the right
  }
}
