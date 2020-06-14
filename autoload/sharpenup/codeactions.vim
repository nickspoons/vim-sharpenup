let s:save_cpo = &cpoptions
set cpoptions&vim

function! sharpenup#codeactions#Count() abort
  let opts = {
  \ 'CallbackCount': function('sharpenup#codeactions#CBReturnCount'),
  \ 'CallbackCleanup': {-> execute('sign unplace 99')}
  \}
  call OmniSharp#actions#codeactions#Count(opts)
endfunction

function! sharpenup#codeactions#CBReturnCount(count) abort
  if a:count
    execute 'sign place 99 line=' . line('.')
    \ 'name=sharpenup_CodeActions file=' . expand('%:p')
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:et:sw=2:sts=2
