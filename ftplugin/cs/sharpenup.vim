if !get(g:, 'sharpenup_loaded', 0) | finish | endif
if get(b:, 'sharpenup_ftplugin_loaded', 0) | finish | endif
let b:sharpenup_ftplugin_loaded = 1
let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')

if g:sharpenup_codeactions && g:sharpenup_codeactions_set_signcolumn
  setlocal signcolumn=yes
  let b:undo_ftplugin .= '| setlocal signcolumn<'
endif

augroup sharpenup_ftplugin
  autocmd! * <buffer>
  for au in split(g:sharpenup_codeactions_autocmd, ',')
    execute 'autocmd' au '<buffer> call sharpenup#CountCodeActions()'
  endfor
augroup END

let b:undo_ftplugin .= '
\| execute "autocmd! sharpenup_ftplugin * <buffer>"
\| unlet b:sharpenup_ftplugin_loaded'

" vim:et:sw=2:sts=2
