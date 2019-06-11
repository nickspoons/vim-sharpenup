function! sharpenup#CountCodeActions() abort
  let opts = {
  \ 'CallbackCount': function('sharpenup#CBReturnCount'),
  \ 'CallbackCleanup': {-> execute('sign unplace 99')}
  \}
  call OmniSharp#CountCodeActions(opts)
endfunction

function! sharpenup#CBReturnCount(count) abort
  if a:count
    execute 'sign place 99 line=' . line('.')
    \ 'name=sharpenup_CodeActions file=' . expand('%:p')
  endif
endfunction

" vim:et:sw=2:sts=2
