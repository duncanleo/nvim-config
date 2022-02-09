command Format :call CocActionAsync('format')

command! -nargs=? Fold :call     CocAction('fold', <f-args>)
