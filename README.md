# Sharpen Up!

This plugin is tightly integrated with [OmniSharp-vim](https://github.com/OmniSharp/omnisharp-vim) for C# development, providing default mappings and integrations that are better defined outside of OmniSharp-vim itself.

## Features

* [Code actions available](#code-actions-available) flag in the sign column
* Customisable [statusline](#statusline) function for displaying server status
* Default [mappings](#mappings)
* Manage file includes in [legacy .csproj](#legacy-csproj-actions) files

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

To display the solution/directory name of the current OmniSharp server, use
`%s`, e.g.:

```vim
let g:sharpenup_statusline_opts = ' O# (%s) '
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

This will work fine but the statusline will only be updated when Vim asks for it, which typically happens on cursor movements and changes etc. To have the server status updated immediately when the server status changes, add this `autocmd`:

```vim
augroup lightline_integration
  autocmd!
  autocmd User OmniSharpStarted,OmniSharpReady,OmniSharpStopped call lightline#update()
augroup END
```

## Mappings

By default, vim-sharpenup creates standard OmniSharp-vim mappings in .cs buffers.
This can be globally disabled like this:

```vim
let g:sharpenup_create_mappings = 0
```

The full list of default mappings is as follows:

```vim
nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
nmap <silent> <buffer> <LocalLeader>osfu <Plug>(omnisharp_find_usages)
nmap <silent> <buffer> <LocalLeader>osfi <Plug>(omnisharp_find_implementations)
nmap <silent> <buffer> <LocalLeader>ospd <Plug>(omnisharp_preview_definition)
nmap <silent> <buffer> <LocalLeader>ospi <Plug>(omnisharp_preview_implementations)

nmap <silent> <buffer> <LocalLeader>ost <Plug>(omnisharp_type_lookup)
nmap <silent> <buffer> <LocalLeader>osd <Plug>(omnisharp_documentation)

nmap <silent> <buffer> <LocalLeader>osfs <Plug>(omnisharp_find_symbol)

nmap <silent> <buffer> <LocalLeader>osfx <Plug>(omnisharp_fix_usings)
nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)

nmap <silent> <buffer> <LocalLeader>osgcc <Plug>(omnisharp_global_code_check)

nmap <silent> <buffer> <LocalLeader>osca <Plug>(omnisharp_code_actions)
xmap <silent> <buffer> <LocalLeader>osca <Plug>(omnisharp_code_actions)

nmap <silent> <buffer> <LocalLeader>osnm <Plug>(omnisharp_rename)

nmap <silent> <buffer> <LocalLeader>os= <Plug>(omnisharp_code_format)

nmap <silent> <buffer> <LocalLeader>osre <Plug>(omnisharp_restart_server)
nmap <silent> <buffer> <LocalLeader>osst <Plug>(omnisharp_start_server)
nmap <silent> <buffer> <LocalLeader>ossp <Plug>(omnisharp_stop_server)
```

The mappings all use a common prefix, except for these exceptions: `gd`, `<C-\>`, `[[`, `]]`

The default prefix is `<LocalLeader>os`.
The default local-leader in Vim is `\` which means that the default prefixed mappings all begin with `\os`.
This can be overridden either by changing `maplocalleader`, or setting a different prefix:

```vim
" Example mapping: '<Space>osfi'
let maplocalleader = "\<Space>"

" Example mapping: ',fi'
let g:sharpenup_map_prefix = ','
```

## Legacy csproj actions

In older .NET Framework projects, all .cs files are listed explicitly in the .csproj file.
vim-sharpenup provides some functionality for maintaining this style of .csproj file, by adding and renaming referenced .cs files.

The following commands are provided:

- `:SharpenUpAddToProject` add the current .cs file to the .csproj file
- `:SharpenUpRenameInProject` rename the current .cs file in the .csproj file, e.g. `:SharpenUpRenameInProject NewFilename.cs`

When the `g:sharpenup_map_legacy_csproj_actions` flag is set (it is by default), the following mappings are also created (note that the `g:sharpenup_map_prefix` is used, see [mappings](#mappings)):

```vim
nmap <silent> <buffer> <LocalLeader>osadd <Plug>(sharpenup_add_to_csproj)
" Populate the vim command line with the command, waiting for user input:
" :SharpenUpRenameInProject _
nnoremap <buffer> <LocalLeader>osren :SharpenUpRenameInProject<Space>
```
