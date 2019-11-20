if !get(g:, 'sharpenup_loaded', 0) | finish | endif
if get(b:, 'sharpenup_ftplugin_loaded', 0) | finish | endif
let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
let b:sharpenup_ftplugin_loaded = 1
let b:undo_ftplugin .= '| unlet b:sharpenup_ftplugin_loaded'

function! s:map(mode, lhs, plug) abort
  let l:rhs = '<Plug>(omnisharp_' . a:plug . ')'
  if !hasmapto(l:rhs, substitute(a:mode, 'x', 'v', ''))
  \ && maparg(a:lhs, a:mode) ==# ''
    execute a:mode . 'map <silent> <buffer>' a:lhs l:rhs
  endif
endfunction

if get(g:, 'sharpenup_create_mappings', 1)
  let s:pre = get(g:, 'sharpenup_map_prefix', "\<LocalLeader>os")

  call s:map('n', 'gd', 'go_to_definition')
  call s:map('n', s:pre . 'fu', 'find_usages')
  call s:map('n', s:pre . 'fi', 'find_implementations')
  call s:map('n', s:pre . 'pd', 'preview_definition')
  call s:map('n', s:pre . 'pi', 'preview_implementation')

  call s:map('n', s:pre . 't', 'type_lookup')
  call s:map('n', s:pre . 'd', 'documentation')

  call s:map('n', s:pre . 'fs', 'find_symbol')

  call s:map('n', s:pre . 'fx', 'fix_usings')
  call s:map('n', '<C-\>', 'signature_help')
  call s:map('i', '<C-\>', 'signature_help')

  call s:map('n', '[[', 'navigate_up')
  call s:map('n', ']]', 'navigate_down')

  call s:map('n', s:pre . 'gcc', 'global_code_check')

  call s:map('n', s:pre . 'hi', 'highlight_types')

  call s:map('n', s:pre . 'ca', 'code_actions')
  call s:map('x', s:pre . 'ca', 'code_actions')

  call s:map('n', s:pre . 'nm', 'rename')

  call s:map('n', s:pre . '=', 'code_format')

  call s:map('n', s:pre . 're', 'restart_server')
  call s:map('n', s:pre . 'st', 'start_server')
  call s:map('n', s:pre . 'sp', 'stop_server')

  call s:map('n', s:pre . 'rt', 'run_test')
  call s:map('n', s:pre . 'rat', 'run_tests_in_file')
endif

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
