let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:HiEcho(message, ...) abort
  let group = a:0 ? a:1 : 'WarningMsg'
  execute 'echohl ' . group
  echomsg a:message
  echohl None
endfunction

" Search from the current directory up to the solution directory for a .csproj
" file, and return the first one found. Note that this may return the wrong
" .csproj file if two .csproj files are found in the same directory.
function! s:FindProject() abort
  let l:base = fnamemodify(OmniSharp#FindSolutionOrDir(), ':h')
  let l:dir = expand('%:p:h')
  while 1
    let l:projects = split(globpath(l:dir, '*.csproj'), '\n')
    if len(l:projects)
      return l:projects[0]
    endif
    let l:parent = fnamemodify(l:dir, ':h')
    if l:dir ==# l:parent || l:dir ==# l:base
      call s:HiEcho('Project not found')
      return ''
    endif
    let l:dir = l:parent
  endwhile
endfunction

" Add the current file to the .csproj. The .csproj must be found in an ancestor
" directory and must already contain at least one .cs file.
function! sharpenup#legacycsproj#AddToProject() abort
  let l:filepath = expand('%:p')
  let l:project = s:FindProject()
  if !len(l:project) | return | endif
  let l:currenttab = tabpagenr()
  execute 'silent tabedit' l:project
  call cursor(1, 1)
  if !search('^\s*<compile include=".*\.cs"', '')
    tabclose
    execute 'tabnext' l:currenttab
    call s:HiEcho('Could not find a .cs entry')
    return
  endif
  normal! yypk
  if fnamemodify(l:project, ':h') !=# getcwd()
    execute 'lcd' fnamemodify(l:project, ':h')
  endif
  let l:filepath = fnamemodify(l:filepath, ':.:gs?/?\\/?')
  execute 'substitute/".*\.cs"/"' . l:filepath . '"/'
  if g:OmniSharp_translate_cygwin_wsl || has('win32')
    substitute?/?\\?g
    substitute?\\>?/>?g
  endif
  silent write
  tabclose
  execute 'tabnext' l:currenttab
endfunction

" Find the current file in the .csproj file and rename it to a:newname.
" Pass in a full path relative to the project.
function! sharpenup#legacycsproj#RenameInProject(newname) abort
  let l:filepath = expand('%:p')
  let l:project = s:FindProject()
  if !len(l:project) | return | endif
  let l:currenttab = tabpagenr()
  execute 'silent tabedit' l:project
  call cursor(1, 1)
  let l:project_dir = fnamemodify(l:project, ':h')
  if l:project_dir !=# getcwd()
    execute 'lcd' fnamemodify(l:project, ':h')
  endif
  let l:filepath = fnamemodify(l:filepath, ':.')
  let l:oldname = l:filepath
  if g:OmniSharp_translate_cygwin_wsl
    let l:filepath = substitute(l:filepath, '/', '\\\\', 'g')
  elseif has('win32')
    let l:filepath = substitute(l:filepath, '\\', '\\\\', 'g')
  endif
  " Search for the full file path, relative to the .csproj
  if !search(l:filepath, '')
    tabclose
    execute 'tabnext' l:currenttab
    call s:HiEcho('Could not find ' . substitute(l:filepath, '\\\\', '\\', 'g'))
    return
  endif
  let l:newpath = a:newname
  if g:OmniSharp_translate_cygwin_wsl
    let l:newpath = substitute(a:newname, '/', '\\\\', 'g')
  elseif has('win32')
    let l:newpath = substitute(a:newname, '\\', '\\\\', 'g')
  endif
  execute 'substitute?' . l:filepath . '?' . l:newpath . '?'
  silent write
  tabclose
  execute 'tabnext' l:currenttab
  if get(g:, 'sharpenup_legacy_csproj_rename_callback', '') !=# ''
    try
      let CB = function(g:sharpenup_legacy_csproj_rename_callback)
      call CB(a:newname, l:oldname, l:project_dir)
    catch /^Vim\%((\a\+)\)\=:\%(E117\):/
      call s:HiEcho(
      \ 'g:sharpenup_legacy_csproj_rename_callback function does not exist: '
      \ . g:sharpenup_legacy_csproj_rename_callback)
    endtry
  endif
endfunction

" Populate the Vim command line with the :SharpenUpRenameInProject command and
" the current filepath, ensuring that the filepath is relative to the project.
function! sharpenup#legacycsproj#RenameInProjectPopulate() abort
  let l:filepath = expand('%:p')
  let l:project = s:FindProject()
  if !len(l:project) | return | endif
  let l:currenttab = tabpagenr()
  execute 'silent tabedit' l:project
  call cursor(1, 1)
  if fnamemodify(l:project, ':h') !=# getcwd()
    execute 'lcd' fnamemodify(l:project, ':h')
  endif
  let l:filepath = fnamemodify(l:filepath, ':.')
  tabclose
  execute 'tabnext' l:currenttab
  call feedkeys(':SharpenUpRenameInProject ' . l:filepath, 'n')
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:et:sw=2:sts=2
