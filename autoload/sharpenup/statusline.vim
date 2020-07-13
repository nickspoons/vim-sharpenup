let s:save_cpo = &cpoptions
set cpoptions&vim

let s:t_ignore = -1
let s:t_loading = 0
let s:t_ready = 1
let s:t_dead = 2
let s:t_invalid = 9
function! sharpenup#statusline#GetStatus() abort
  call s:StatusInit()
  let status = {
  \ 'State': s:t_ignore,
  \ 'Text': ''
  \}
  if &filetype !=# 'cs' | return status | endif
  if !g:OmniSharp_server_stdio
    let status.State = s:t_invalid
    let status.Text = ' O#: Invalid server '
    return status
  endif

  let host = OmniSharp#GetHost(bufnr('%'))
  if type(host.job) != v:t_dict || get(host.job, 'stopped')
    let status.State = s:t_dead
    let status.Text = substitute(s:statusOpts.TextDead, '%s', '-', 'g')
    return status
  endif

  let loaded = get(host.job, 'loaded', 0)
  let status.State = loaded ? s:t_ready : s:t_loading
  let status.Text = loaded ? s:statusOpts.TextReady : s:statusOpts.TextLoading
  if stridx(status.Text, '%s') >= 0
    let sod = fnamemodify(host.sln_or_dir, ':t')
    let status.Text = substitute(status.Text, '%s', sod, 'g')
  endif
  if match(status.Text, '%p\c') >= 0
    try
      let projectsloaded = OmniSharp#project#CountLoaded()
      let projectstotal = OmniSharp#project#CountTotal()
    catch
      " The CountLoaded and CountTotal functions are very new - catch the error
      " when they don't exist
      let projectsloaded = 0
      let projectstotal = 0
    endtry
    let status.Text = substitute(status.Text, '%p\C', projectsloaded, 'g')
    let status.Text = substitute(status.Text, '%P\C', projectstotal, 'g')
  endif
  return status
endfunction

function! sharpenup#statusline#StatusText(statustype) abort
  let status = sharpenup#statusline#GetStatus()
  return status.State == a:statustype ? status.Text : ''
endfunction

function! sharpenup#statusline#Build() abort
  call s:StatusInit()
  return
  \ sharpenup#statusline#BuildSegment(s:t_loading, s:statusOpts.HiLoading) .
  \ sharpenup#statusline#BuildSegment(s:t_ready, s:statusOpts.HiReady) .
  \ sharpenup#statusline#BuildSegment(s:t_dead, s:statusOpts.HiDead)
endfunction

function! sharpenup#statusline#BuildSegment(state, ...) abort
  let segment = ''
  if s:statusOpts.Highlight
    if a:0
      let group = a:1
    else
      let group =
      \ a:state == s:t_loading ? s:statusOpts.HiLoading :
      \ a:state == s:t_ready ? s:statusOpts.HiReady :
      \ a:state == s:t_dead ? s:statusOpts.HiDead : 'Normal'
    endif
    let segment .= '%#' . group . '#'
  endif
  let segment .= '%{sharpenup#statusline#StatusText(' . a:state . ')}'
  if s:statusOpts.Highlight
    let segment .= '%*'
  endif
  return segment
endfunction

function! s:StatusInit() abort
  if exists('s:statusOpts') | return | endif

  " Setup for first use
  let s:statusOpts = {
  \ 'TextLoading': ' O#: %s loading... (%p of %P) ',
  \ 'TextReady': ' O#: %s ',
  \ 'TextDead': ' O#: Not running ',
  \ 'Highlight': 1,
  \ 'HiLoading': 'SharpenUpLoading',
  \ 'HiReady': 'SharpenUpReady',
  \ 'HiDead': 'SharpenUpDead'
  \}
  if exists('g:sharpenup_statusline_opts')
    let gs = g:sharpenup_statusline_opts
    if type(gs) == type('')
      " A string value for g:sharpenup_statusline_opts replaces all status texts
      let s:statusOpts.TextLoading = gs
      let s:statusOpts.TextReady = gs
      let s:statusOpts.TextDead = gs
    elseif type(gs) == type({})
      if has_key(gs, 'TextLoading') || has_key(gs, 'Text')
        let s:statusOpts.TextLoading = get(gs, 'TextLoading', get(gs, 'Text'))
      endif
      if has_key(gs, 'TextReady') || has_key(gs, 'Text')
        let s:statusOpts.TextReady = get(gs, 'TextReady', get(gs, 'Text'))
      endif
      if has_key(gs, 'TextDead') || has_key(gs, 'Text')
        let s:statusOpts.TextDead = get(gs, 'TextDead', get(gs, 'Text'))
      endif
      if !get(gs, 'Highlight', 1)
        let s:statusOpts.Highlight = 0
      endif
      if has_key(gs, 'HiLoading')
        let s:statusOpts.HiLoading = gs.HiLoading
      endif
      if has_key(gs, 'HiReady')
        let s:statusOpts.HiReady = gs.HiReady
      endif
      if has_key(gs, 'HiDead')
        let s:statusOpts.HiDead = gs.HiDead
      endif
    endif
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:et:sw=2:sts=2
