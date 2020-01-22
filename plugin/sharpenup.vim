if exists('g:sharpenup_loaded') | finish | endif
let g:sharpenup_loaded = 1

scriptencoding utf-8

let g:sharpenup_codeactions =
\ get(g:, 'sharpenup_codeactions', exists('+signcolumn'))
let g:sharpenup_codeactions_autocmd =
\ get(g:, 'sharpenup_codeactions_autocmd', 'CursorHold')
let g:sharpenup_codeactions_glyph =
\ get(g:, 'sharpenup_codeactions_glyph', '💡')
let g:sharpenup_codeactions_set_signcolumn =
\ get(g:, 'sharpenup_codeactions_set_signcolumn', 1)

if g:sharpenup_codeactions
  execute 'sign define sharpenup_CodeActions text=' .
  \ g:sharpenup_codeactions_glyph
endif

" Default highlight groups for sharpenup#statusline#Build()
highlight default link SharpenUpLoading WarningMsg
highlight default link SharpenUpReady Directory
highlight default link SharpenUpDead NonText

" vim:et:sw=2:sts=2
