let s:save_cpo = &cpoptions
set cpoptions&vim

function! sharpenup#codeactions#Count() abort
  let opts = {
  \ 'CallbackCount': function('s:CBReturnCount', [bufnr(), line('.')]),
  \ 'CallbackCleanup': {-> execute('sign unplace * group=sharpenup_CodeActions')}
  \}
  call OmniSharp#actions#codeactions#Count(opts)
endfunction

function! s:CBReturnCount(bufnr, line, count) abort
  if a:count
    execute 'sign place 99'
    \ 'line=' . a:line
    \ 'name=sharpenup_CodeActions'
    \ 'group=sharpenup_CodeActions'
    \ 'file=' . bufname(a:bufnr)
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:et:sw=2:sts=2
