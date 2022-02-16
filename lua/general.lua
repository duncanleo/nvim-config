-- Auto resize
vim.api.nvim_command('autocmd VimResized * wincmd =')

vim.api.nvim_set_keymap(
  'n',
  '<C-l>',
  ':set invnumber<CR>',
  { noremap = true }
)
