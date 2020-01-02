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
      echohl WarningMsg | echomsg 'Project not found' | echohl None
      return ''
    endif
    let l:dir = l:parent
  endwhile
endfunction

" Add the current file to the .csproj. The .csproj must be found in an ancestor
" directory and must already contain at least one .cs file.
function! sharpenup#legacycsproj#AddToProject() abort
  let l:filename = expand('%:p')
  let l:project = s:FindProject()
  if !len(l:project) | return | endif
  execute 'silent tabedit' l:project
  call cursor(1, 1)
  if !search('^\s*<compile include=".*\.cs"', '')
    tabclose
    echohl WarningMsg | echomsg 'Could not find a .cs entry' | echohl None
    return
  endif
  normal! yypk
  if fnamemodify(l:project, ':h') !=# getcwd()
    execute 'lcd' fnamemodify(l:project, ':h')
  endif
  execute 's/".*\.cs"/"' . fnamemodify(l:filename, ':.:gs?/?\\/?') . '"/'
  if g:OmniSharp_translate_cygwin_wsl || has('win32')
    s?/?\\?g
    s?\\>?/>?g
  endif
  write
  tabclose
endfunction

" Find the current file in the .csproj file and rename it to a:newname.
" Do not pass in a full path - just the new filename.cs
function! sharpenup#legacycsproj#RenameInProject(newname) abort
  let l:filepath = expand('%:p')
  let l:filename = expand('%:t')
  let l:project = s:FindProject()
  if !len(l:project) | return | endif
  execute 'silent tabedit' l:project
  call cursor(1, 1)
  if fnamemodify(l:project, ':h') !=# getcwd()
    execute 'lcd' fnamemodify(l:project, ':h')
  endif
  let l:filepath = fnamemodify(l:filepath, ':.')
  if g:OmniSharp_translate_cygwin_wsl || has('win32')
    let l:filepath = substitute(l:filepath, '/', '\\\\', 'g')
  endif
  " Search for the full file path, relative to the .csproj
  if !search(l:filepath, '')
    " If not found, try just the file name (without the path)
    if !search(fnamemodify(l:filepath, ':t'), '')
      tabclose
      echohl WarningMsg | echomsg 'Could not find ' . l:filepath | echohl None
      return
    endif
  endif
  execute 's/' . fnamemodify(l:filename, ':t') . '/' . a:newname . '/'
  write
  tabclose
endfunction
