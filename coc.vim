" adapted from https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim#tool-tip-documentation-and-diagnostics
function! ShowDocIfNoDiagnostic(timer_id)
  if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
    silent call CocActionAsync('doHover')
  endif
endfunction

function! s:show_hover_doc()
  call timer_start(500, 'ShowDocIfNoDiagnostic')
endfunction

autocmd CursorHoldI * :call <SID>show_hover_doc()
autocmd CursorHold * :call <SID>show_hover_doc()

command Format :call CocActionAsync('format')

command! -nargs=? Fold :call     CocAction('fold', <f-args>)
