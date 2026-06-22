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
-- Cap the commit summary so a long message doesn't crowd out the statusline.
vim.g.gitblame_max_commit_summary_length = 40

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
      -- path = 1: show path relative to cwd. shorting_target: shorten directory
      -- segments to leave ~40 columns for the rest of the statusline.
      { 'filename', path = 1, shorting_target = 40 }
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
