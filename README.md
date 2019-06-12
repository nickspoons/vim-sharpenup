# Sharpen Up!

This plugin is tightly integrated with [OmniSharp-vim](https://github.com/OmniSharp/omnisharp-vim) for C# development, providing default mappings and integrations that are better defined outside of OmniSharp-vim itself.

## Features

* [Code actions available](#code-actions-available) flag in the sign column
* Customisable [statusline](#statusline) function for displaying server status

## 💡 Code actions available

A flag is displayed in the sign column to indicate that one or more code actions are available.

#### Options

| Variable name                            | Default        |                                                              |
|------------------------------------------|----------------|--------------------------------------------------------------|
| `g:sharpenup_codeactions`                | `1`            | Set to `0` to disable this feature                           |
| `g:sharpenup_codeactions_autocmd`        | `'CursorHold'` | Which autocmd to trigger on - can be a comma separated list. Suggestions: `CursorHold`, `CursorMoved`, `BufEnter,CursorMoved` |
| `g:sharpenup_codeactions_glyph`          | `'💡'`         | Select the character to be used as the sign-column indicator |
| `g:sharpenup_codeactions_set_signcolumn` | `1`            | `'signcolumn'` will be set to `yes` for .cs buffers          |

## Statusline

The status of the current OmniSharp server can be added to your statusline using SharpenUp helper functions.
The statusline flag can be particularly useful when working with multiple solutions in a single Vim session, as each buffer shows the status of the solution the buffer belongs to.

**Note:** The statusline function does not support the HTTP server, Stdio only.

#### Customisation

The `g:sharpenup_statusline_opts` variable can be used to customise the text and highlighting of the statusline.

The defaults are as follows:

```vim
let g:sharpenup_statusline_opts = {
\ 'TextLoading': ' O#: Loading... ',
\ 'TextReady': ' O# ',
\ 'TextDead': ' O#: Not running ',
\ 'Highlight': 1,
\ 'HiLoading': 'SharpenUpLoading',
\ 'HiReady': 'SharpenUpReady',
\ 'HiDead': 'SharpenUpDead'
\}
```

The texts can be set individually, or using property `Text`.
A shortcut is to simply assign a text value to `g:sharpenup_statusline_opts`, which is equivalent to only setting the `Text` property:

```vim
" Use a single glyph in the statusline, and allow the highlight groups to indicate server status
let g:sharpenup_statusline_opts = '•'
```

To change the highlight colours, either:

* assign different highlight groups to be used:
  ```vim
  let g:sharpenup_statusline_opts = { 'HiLoading': 'NonText' }
  ```
* link the SharpenUp highlight groups to something else:
  ```vim
  highlight link SharpenUpReady ModeMsg
  ```
* set the SharpenUp highlight groups directly:
  ```vim
  highlight SharpenUpReady ctermfg=66 guifg=#458588
  ```
* or just disable highlighting:
  ```vim
  let g:sharpenup_statusline_opts = { 'Highlight': 0 }
  ```

#### Vanilla

The simplest way to use the statusline function is to include it in `'statusline'`, e.g.:

```vim
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V
let &statusline .= sharpenup#statusline#Build()
set statusline+=\ %P
```

#### Lightline

When using [lightline.vim](https://github.com/itchyny/lightline.vim) you can also include the OmniSharp server status with the `sharpenup#statusline#Build()` function.
Here's an example:

```vim
let g:lightline = {
\ 'active': {
\   'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype', 'sharpenup']]
\ },
\ 'inactive': {
\   'right': [['lineinfo'], ['percent'], ['sharpenup']]
\ },
\ 'component': {
\   'sharpenup': sharpenup#statusline#Build()
\ }
\}
let g:sharpenup_statusline_opts = { 'Highlight': 0 }
```

Highlighting has been disabled in `g:sharpenup_statusline_opts` in this example, meaning that the default statusline texts will be displayed ("O#: Loading...", "O#", "O#: Not running") in the statusline colours.
