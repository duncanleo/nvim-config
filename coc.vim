command Format :call CocActionAsync('format')

command! -nargs=? Fold :call     CocAction('fold', <f-args>)

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
