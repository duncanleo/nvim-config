-- Re-equalize window sizes whenever the terminal/GUI is resized.
vim.api.nvim_command('autocmd VimResized * wincmd =')

-- <C-l>: toggle line numbers on/off.
vim.api.nvim_set_keymap(
  'n',
  '<C-l>',
  ':set invnumber<CR>',
  { noremap = true }
)

-- Close the current buffer without closing its window (so it never quits Neovim
-- or collapses the editor window into the nvim-tree pane). We switch the window
-- to another listed buffer first, then delete the old one; a plain :bd would
-- close the window when the tree is open. Fall back to a blank buffer if none.
local function close_buffer()
  local cur = vim.api.nvim_get_current_buf()
  local others = vim.tbl_filter(function(b)
    return b ~= cur and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())
  if #others > 0 then
    vim.cmd('bprevious')
  else
    vim.cmd('enew')
  end
  if vim.api.nvim_buf_is_valid(cur) then
    vim.cmd('bdelete ' .. cur)
  end
end

-- <leader>q: close the current buffer, keep the window (and Neovim) open.
vim.keymap.set('n', '<leader>q', close_buffer, { desc = 'Close buffer, keep window' })
