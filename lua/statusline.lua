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

-- https://github.com/nvim-lualine/lualine.nvim/wiki/FAQ#my-tabline-updates-infrequently
if _G.Tabline_timer == nil then
  _G.Tabline_timer = vim.loop.new_timer()
else
  _G.Tabline_timer:stop()
end

_G.Tabline_timer:start(
  0,             -- never timeout
  5000,          -- repeat every 5000 ms
  vim.schedule_wrap(function() -- updater function
     vim.api.nvim_command('redrawtabline')
  end)
)
