-- Re-equalize window sizes whenever the terminal/GUI is resized.
vim.api.nvim_command('autocmd VimResized * wincmd =')

-- <C-l>: toggle line numbers on/off.
vim.api.nvim_set_keymap(
  'n',
  '<C-l>',
  ':set invnumber<CR>',
  { noremap = true }
)
