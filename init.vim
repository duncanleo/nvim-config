call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug '/opt/homebrew/opt/fzf'
Plug 'neoclide/jsonc.vim'
Plug 'junegunn/fzf.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'morhetz/gruvbox'

call plug#end()

" coc.nvim plugins
let g:coc_global_extensions = [
                  \ 'coc-tsserver',
                  \ 'coc-explorer',
                  \ 'coc-python',
                  \ 'coc-solargraph',
                  \ 'coc-go',
                  \ 'coc-json',
                  \ 'coc-yaml',
                  \ 'coc-phpls',
                  \ ]

" coc-explorer
autocmd VimEnter * CocCommand explorer

" disable netrw
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

let g:ale_fixers = {
      \ 'javascript': ['prettier', 'eslint'],
      \ 'javascriptreact': ['prettier', 'eslint'],
      \ 'typescript': ['eslint'],
      \ 'typescriptreact': ['eslint'],
      \ 'go': ['gofmt'],
      \ 'php': ['php_cs_fixer']
      \ }
let g:ale_fix_on_save = 1

command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" tsconfig.json is actually jsonc, help TypeScript set the correct filetype
autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc

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
colorscheme gruvbox

source $HOME/.config/nvim/plug-config/coc.vim
