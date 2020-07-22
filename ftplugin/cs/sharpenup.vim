if !get(g:, 'sharpenup_loaded', 0) | finish | endif
if get(b:, 'sharpenup_ftplugin_loaded', 0) | finish | endif
let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
let b:sharpenup_ftplugin_loaded = 1
let b:undo_ftplugin .= '| unlet b:sharpenup_ftplugin_loaded'

let s:save_cpo = &cpoptions
set cpoptions&vim

command! -buffer SharpenUpAddToProject call sharpenup#legacycsproj#AddToProject()
command! -buffer -nargs=1 SharpenUpRenameInProject call sharpenup#legacycsproj#RenameInProject(<q-args>)

nnoremap <buffer> <Plug>(sharpenup_add_to_csproj) :call sharpenup#legacycsproj#AddToProject()<CR>
nnoremap <buffer> <Plug>(sharpenup_rename_in_csproj) :call sharpenup#legacycsproj#RenameInProjectPopulate()<CR>

function! s:map(mode, lhs, plug) abort
  let l:rhs = '<Plug>(' . a:plug . ')'
  if !hasmapto(l:rhs, substitute(a:mode, 'x', 'v', ''))
  \ && maparg(a:lhs, a:mode) ==# ''
    execute a:mode . 'map <silent> <buffer>' a:lhs l:rhs
  endif
endfunction

let s:pre = get(g:, 'sharpenup_map_prefix', "\<LocalLeader>os")

if get(g:, 'sharpenup_create_mappings', 1)
  call s:map('n', 'gd', 'omnisharp_go_to_definition')
  call s:map('n', s:pre . 'fu', 'omnisharp_find_usages')
  call s:map('n', s:pre . 'fi', 'omnisharp_find_implementations')
  call s:map('n', s:pre . 'pd', 'omnisharp_preview_definition')
  call s:map('n', s:pre . 'pi', 'omnisharp_preview_implementation')

  call s:map('n', s:pre . 't', 'omnisharp_type_lookup')
  call s:map('n', s:pre . 'd', 'omnisharp_documentation')

  call s:map('n', s:pre . 'fs', 'omnisharp_find_symbol')
  call s:map('n', s:pre . 'ft', 'omnisharp_find_type')

  call s:map('n', s:pre . 'fx', 'omnisharp_fix_usings')

  call s:map('n', '<C-\>', 'omnisharp_signature_help')
  call s:map('i', '<C-\>', 'omnisharp_signature_help')

  call s:map('n', '[[', 'omnisharp_navigate_up')
  call s:map('n', ']]', 'omnisharp_navigate_down')

  call s:map('n', s:pre . 'gcc', 'omnisharp_global_code_check')

  call s:map('n', s:pre . 'hi', 'omnisharp_highlight_types')

  call s:map('n', s:pre . 'ca', 'omnisharp_code_actions')
  call s:map('x', s:pre . 'ca', 'omnisharp_code_actions')
  call s:map('n', s:pre . '.', 'omnisharp_code_action_repeat')
  call s:map('x', s:pre . '.', 'omnisharp_code_action_repeat')

  call s:map('n', s:pre . 'nm', 'omnisharp_rename')

  call s:map('n', s:pre . '=', 'omnisharp_code_format')

  call s:map('n', s:pre . 're', 'omnisharp_restart_server')
  call s:map('n', s:pre . 'st', 'omnisharp_start_server')
  call s:map('n', s:pre . 'sp', 'omnisharp_stop_server')

  call s:map('n', s:pre . 'rt', 'omnisharp_run_test')
  call s:map('n', s:pre . 'rat', 'omnisharp_run_tests_in_file')
endif

if get(g:, 'sharpenup_map_legacy_csproj_actions', 1)
  call s:map('n', s:pre . 'xa', 'sharpenup_add_to_csproj')
  call s:map('n', s:pre . 'xr', 'sharpenup_rename_in_csproj')
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

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:et:sw=2:sts=2
