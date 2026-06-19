require('plugins')
require('general')
require('lsp')

-- nvim_tree
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = 'NvimTree_*',
  command = 'set cursorline',
})
require('nvim_tree')
require('statusline')
require('menu_setup')

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- tsconfig.json is actually jsonc, help TypeScript set the correct filetype
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'tsconfig.json',
  command = 'set filetype=jsonc',
})

-- map F to Files command
vim.api.nvim_create_user_command('F', 'Files', {})

-- disable python recommended styles built into vim
vim.g.python_recommended_style = 0

-- disable the native vim 'INSERT' etc because lightline already shows it
vim.opt.showmode = false

-- others
vim.opt.mouse = 'a'
-- free <RightMouse> for the nvzone/menu mapping (default 'popup_setpos'
-- reserves the right button for Neovim's built-in PopUp menu)
vim.opt.mousemodel = 'extend'
vim.opt.backspace = 'indent,eol,start' -- let backspace cross line/indent boundaries

-- Indentation: 2-space soft tabs everywhere.
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Keep swap/backup/undo files out of the working tree, in a single scratch dir.
vim.opt.backupdir = vim.fn.expand('~/.vim/tmp')
vim.opt.directory = vim.fn.expand('~/.vim/tmp')
vim.opt.undodir = vim.fn.expand('~/.vim/tmp')
vim.opt.backupcopy = 'yes' -- write backups by copying (preserves file inode/permissions)

-- NOTE: the `ansi` colorscheme below forces termguicolors OFF (it's a cterm
-- scheme), so this `true` is effectively overridden once the scheme loads.
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.opt.splitright = true -- vertical splits open to the right
vim.opt.splitbelow = true -- horizontal splits open below
vim.opt.switchbuf = 'useopen,usetab' -- jump to an existing window/tab instead of reopening a buffer
vim.opt.cursorline = true
vim.cmd.colorscheme('ansi')
