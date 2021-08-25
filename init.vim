call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug '/opt/homebrew/opt/fzf'
Plug 'neoclide/jsonc.vim'
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'bagrat/vim-buffet'
Plug 'honza/vim-snippets'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

call plug#end()

" coc.nvim plugins
let g:coc_global_extensions = [
                  \ 'coc-tsserver',
                  \ 'coc-pyright',
                  \ 'coc-solargraph',
                  \ 'coc-go',
                  \ 'coc-json',
                  \ 'coc-yaml',
                  \ 'coc-phpls',
                  \ 'coc-git',
                  \ 'coc-html',
                  \ 'coc-css',
                  \ 'coc-snippets',
                  \ 'coc-eslint',
                  \ 'coc-prettier',
                  \ 'coc-highlight',
                  \ ]

" nvim_tree
lua  require('nvim_tree')
let g:nvim_tree_auto_open = 1
let g:nvim_tree_auto_close = 1
let g:nvim_tree_highlight_opened_files = 1
let g:nvim_tree_lsp_diagnostics = 1
let g:nvim_tree_follow = 1
autocmd BufEnter NvimTree set cursorline
nnoremap <C-n> :NvimTreeToggle<CR>
" focus back to nvim_tree pane
nnoremap <C-e> :sb NvimTree<CR>

" disable netrw
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" tsconfig.json is actually jsonc, help TypeScript set the correct filetype
autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc

let g:coc_filetype_map = {
  \ 'yaml.docker-compose': 'yaml',
  \ }

command Format :call CocActionAsync('format')

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
  \   'enable': {
  \     'tabline': 0,
  \   },
  \   'component_function': {
  \     'blame': 'LightlineGitBlame',
  \     'cocstatus': 'coc#status',
  \     'currentfunction': 'CocCurrentFunction',
  \     'filename': 'LightlineFileName',
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
