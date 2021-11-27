local lualine = require 'lualine'

lualine.setup {
  options = {
    theme = 'gruvbox'
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = { 'g:coc_status' },
    lualine_c = {'b:coc_git_blame'},
    lualine_x = {
      {
        'filename',
        path = 1,
        shorting_target = 40
      }
    },
    lualine_y = {'encoding', 'filetype'},
    lualine_z = {'location'}
  },
}
