-- Statusline (lualine) + git blame. The statusline shows mode / filename /
-- diagnostics / diff / file info / location; the tabline lists buffers and tabs.
local lualine = require 'lualine'

-- Show the blame as inline virtual text at the end of the current line. Set
-- before git-blame.nvim initializes so it picks up the preference on load.
vim.g.gitblame_display_virtual_text = 1

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
    lualine_c = { diagnostics },
    lualine_x = { 'diff' },             -- git add/change/delete counts
    lualine_y = { 'encoding', 'filetype' },
    lualine_z = { 'location' }          -- line:col
  },
  tabline = {
    lualine_b = { 'buffers' }, -- open buffers on the left
    lualine_z = { 'tabs' }     -- tab pages on the right
  }
}
