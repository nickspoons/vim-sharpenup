# Sharpen Up!

This plugin is tightly integrated with [OmniSharp-vim](https://github.com/OmniSharp/omnisharp-vim) for C# development, providing default mappings and integrations that are better defined outside of OmniSharp-vim itself.

## Features

* 💡 "Code actions available" flag in the sign column

#### Code actions available

A flag is displayed in the sign column to indicate that one or more code actions are available.

Options:

| Variable name and default value                      |                                                              |
|------------------------------------------------------|--------------------------------------------------------------|
| `let g:sharpenup_codeactions = 1`                    | Set to 0 to disable this feature                             |
| `let g:sharpenup_codeactions_autocmd = 'CursorHold'` | Which autocmd to trigger on - can be a comma separated list. Suggestions: `CursorHold`, `CursorMoved`, `BufEnter,CursorMoved` |
| `let g:sharpenup_codeactions_glyph = '💡'`           | Select the character to be used as the sign-column indicator |
| `let g:sharpenup_codeactions_set_signcolumn = 1`     | 'signcolumn' will be set to 'yes' for .cs buffers            |
