vim.g.coc_global_extensions = {
  'coc-tsserver',
  'coc-pyright',
  'coc-solargraph',
  'coc-go',
  'coc-json',
  'coc-yaml',
  'coc-phpls',
  'coc-git',
  'coc-html',
  'coc-css',
  'coc-snippets',
  'coc-eslint',
  'coc-prettier',
  'coc-highlight',
  'coc-vetur',
  'coc-sumneko-lua',
  'coc-rls'
}

vim.g.coc_filetype_map = {
  ['yaml.docker-compose'] = 'yaml',
  ['yaml.ansible'] = 'yaml'
}

vim.api.nvim_set_keymap(
  'n',
  'ff',
  ":call CocActionAsync('format')<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  'n',
  'gr',
  ":call CocActionAsync('rename')<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  'n',
  'gd',
  ":call CocActionAsync('jumpDefinition')<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  'n',
  'gf',
  "<Plug>(coc-references)",
  { }
)

vim.api.nvim_set_keymap(
  'n',
  'K',
  ":call CocActionAsync('doHover')<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  'n',
  '<leader>do',
  ":call CocActionAsync('codeAction')<CR>",
  {}
)
