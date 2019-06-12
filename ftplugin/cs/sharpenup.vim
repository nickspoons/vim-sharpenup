if !get(g:, 'sharpenup_loaded', 0) | finish | endif
if get(b:, 'sharpenup_ftplugin_loaded', 0) | finish | endif
let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
let b:sharpenup_ftplugin_loaded = 1
let b:undo_ftplugin .= '| unlet b:sharpenup_ftplugin_loaded'


if g:sharpenup_codeactions
  if g:sharpenup_codeactions_set_signcolumn
    setlocal signcolumn=yes
    let b:undo_ftplugin .= '| setlocal signcolumn<'
  endif

  augroup sharpenup_ftplugin
    autocmd! * <buffer>
    for au in split(g:sharpenup_codeactions_autocmd, ',')
      execute 'autocmd' au '<buffer> call sharpenup#codeactions#Count()'
    endfor
  augroup END

  let b:undo_ftplugin .= '| execute "autocmd! sharpenup_ftplugin * <buffer>"'
endif

" vim:et:sw=2:sts=2
