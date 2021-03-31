call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug '/opt/homebrew/opt/fzf'
Plug 'neoclide/jsonc.vim'
Plug 'junegunn/fzf.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'bagrat/vim-buffet'

call plug#end()

" coc.nvim plugins
let g:coc_global_extensions = [
                  \ 'coc-tsserver',
                  \ 'coc-explorer',
                  \ 'coc-pyright',
                  \ 'coc-solargraph',
                  \ 'coc-go',
                  \ 'coc-json',
                  \ 'coc-yaml',
                  \ 'coc-phpls',
                  \ 'coc-git',
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
      \ 'php': ['php_cs_fixer'],
      \ }
let g:ale_fix_on_save = 1

command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" tsconfig.json is actually jsonc, help TypeScript set the correct filetype
autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc

" disable python recommended styles built into vim
let g:python_recommended_style = 0

" functions for lightline status

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! LightlineGitBlame() abort
  let blame = get(b:, 'coc_git_blame', '')
  " return blame
  return winwidth(0) > 120 ? blame : ''
endfunction

function! LightlineFileName()
  let l:filePath = expand('%:.')
  if winwidth(0) > 120
      return l:filePath
  else
      return pathshorten(l:filePath)
  endif
endfunction

" lightline
let g:lightline = {
  \   'active': {
  \     'left': [
  \       [ 'mode', 'paste' ],
  \       [ 'ctrlpmark', 'git', 'diagnostic', 'cocstatus', 'filename', 'method' ]
  \     ],
  \     'right':[
  \       [ 'filetype', 'fileencoding', 'lineinfo'],
  \       [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
  \       [ 'blame' ]
  \     ],
  \   },
  \   'component_function': {
  \     'blame': 'LightlineGitBlame',
  \     'cocstatus': 'coc#status',
  \     'currentfunction': 'CocCurrentFunction',
  \     'filename': 'LightlineFileName',
  \   },
  \   'component_expand': {
  \     'linter_checking': 'lightline#ale#checking',
  \     'linter_infos': 'lightline#ale#infos',
  \     'linter_warnings': 'lightline#ale#warnings',
  \     'linter_errors': 'lightline#ale#errors',
  \     'linter_ok': 'lightline#ale#ok',
  \   },
  \   'component_type': {
  \     'linter_checking': 'right',
  \     'linter_infos': 'right',
  \     'linter_warnings': 'warning',
  \     'linter_errors': 'error',
  \     'linter_ok': 'right',
  \   }
  \ }

" disable the native vim 'INSERT' etc because lightline already shows it
set noshowmode

" lightline ale use icons
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_infos = "\uf129"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"

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

