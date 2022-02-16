runtime plug.vim

lua require('general')

lua require('coc')
runtime coc.vim

" nvim_tree
autocmd BufWinEnter NvimTree set cursorline
lua require('nvim_tree')
lua require('statusline')

" disable netrw
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" tsconfig.json is actually jsonc, help TypeScript set the correct filetype
autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc

" map F to Files command
command F :Files

" disable python recommended styles built into vim
let g:python_recommended_style = 0

" disable the native vim 'INSERT' etc because lightline already shows it
set noshowmode

" others
set mouse=a
set backspace=indent,eol,start
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set backupdir=~/.vim/tmp
set directory=~/.vim/tmp
set undodir=~/.vim/tmp
set backupcopy=yes

set termguicolors
set background=dark
set splitright
set splitbelow
set updatetime=500
set switchbuf=useopen,usetab
colorscheme gruvbox

