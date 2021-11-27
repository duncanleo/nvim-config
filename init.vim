runtime plug.vim

lua require('coc')

" nvim_tree
autocmd BufWinEnter NvimTree set cursorline
lua  require('nvim_tree')

" disable netrw
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" tsconfig.json is actually jsonc, help TypeScript set the correct filetype
autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc

command Format :call CocActionAsync('format')

" disable python recommended styles built into vim
let g:python_recommended_style = 0

" disable the native vim 'INSERT' etc because lightline already shows it
set noshowmode

" vim-buffet configuration
let g:buffet_use_devicons	= 1
let g:buffet_powerline_separators = 1
let g:buffet_tab_icon = "\uf00a"
let g:buffet_left_trunc_icon = "\uf0a8"
let g:buffet_right_trunc_icon = "\uf0a9"

function! g:BuffetSetCustomColors()
  hi! BuffetCurrentBuffer    gui=NONE guibg=#afdf01 guifg=#015f00
  hi! BuffetActiveBuffer     gui=NONE guibg=#585858 guifg=#ffffff
  hi! BuffetBuffer           gui=NONE guibg=#262626 guifg=#4f4f4f
  hi! BuffetModCurrentBuffer gui=NONE guibg=#ffffff guifg=#015f5f
  hi! BuffetModActiveBuffer  gui=NONE guibg=#ffb86c guifg=#282a36
  hi! BuffetModBuffer        gui=NONE guibg=#ff5555 guifg=#282a36
  hi! BuffetTrunc            gui=NONE guibg=#bd93f9 guifg=#282a36
  hi! BuffetTab              gui=NONE guibg=#585858 guifg=#ffffff
endfunction

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

source $HOME/.config/nvim/plug-config/coc.vim
