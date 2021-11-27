local lualine = require 'lualine'

lualine.setup {
  options = {
    theme = 'gruvbox',
    disabled_filetypes = { 'NvimTree' }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      {
        'filename',
        path = 1,
      }
    },
    lualine_c = {},
    lualine_x = {'diff'},
    lualine_y = {'encoding', 'filetype'},
    lualine_z = {'location'}
  },
  tabline = {
    lualine_a = {'g:coc_status'},
    lualine_b = {'buffers'},
    lualine_c = {'b:coc_git_blame'},
    lualine_x = {},
    lualine_y = {'diagnostics'},
    lualine_z = {'tabs'}
  }
}
