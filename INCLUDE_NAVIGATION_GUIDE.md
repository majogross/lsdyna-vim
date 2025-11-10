# LS-DYNA Vim Plugin - INCLUDE File Navigation Guide

The LS-DYNA Vim plugin provides convenient navigation between INCLUDE files, allowing you to quickly open referenced files without leaving Vim.

## Overview

LS-DYNA models often split large input decks into multiple files using `*INCLUDE` or `*INCLUDE_PATH` keywords. This plugin allows you to open these included files directly from within Vim with simple keystrokes.

## How It Works

When your cursor is on an `*INCLUDE` or `*INCLUDE_PATH` line, you can open the referenced file using standard Vim file navigation commands.

## Supported Formats

The plugin handles various INCLUDE formats:

```
*INCLUDE
path/to/file.k

*INCLUDE path/to/file.k

*INCLUDE
"path/to/file.k"

*INCLUDE_PATH
path/to/file.k

*INCLUDE_PATH
../includes/material.k
```

## Key Commands

### Opening in New Tab (Recommended)

| Command | Description |
|---------|-------------|
| `gf` | Go to file - opens INCLUDE in new tab |
| `<C-w>gf` | Alternative - opens INCLUDE in new tab |
| `<leader>oi` | Open Include - opens in new tab |

### Opening in Split Window

| Command | Description |
|---------|-------------|
| `<C-w>f` | Opens INCLUDE in horizontal split |
| `<leader>os` | Open in Split - opens in horizontal split |

### Navigation Between Tabs

| Command | Description |
|---------|-------------|
| `gt` | Go to next tab |
| `gT` | Go to previous tab |
| `2gt` | Go to tab number 2 |
| `:tabc` | Close current tab |
| `:tabo` | Close all other tabs |

## Usage Examples

### Example 1: Opening a Single Include

```lsdyna
*KEYWORD
*INCLUDE
materials.k
*NODE
...
```

1. Move cursor to the `*INCLUDE` line
2. Press `gf`
3. The file `materials.k` opens in a new tab
4. Edit as needed
5. Press `:tabc` or `gt` to go back

### Example 2: Navigating Through Multiple Includes

```lsdyna
*KEYWORD
*INCLUDE
nodes.k
*INCLUDE
elements.k
*INCLUDE
materials.k
*INCLUDE
contacts.k
```

Workflow:
```
1. Cursor on "*INCLUDE" for nodes.k
2. Press gf - opens nodes.k in tab 2
3. Press gt - returns to main file
4. Move to next *INCLUDE line
5. Press gf - opens elements.k in tab 3
6. Continue navigating with gt/gT
```

### Example 3: Working with Nested Includes

Main file `model.k`:
```lsdyna
*KEYWORD
*INCLUDE
mesh/all_mesh.k
```

File `mesh/all_mesh.k`:
```lsdyna
*INCLUDE
nodes.k
*INCLUDE
elements.k
```

Workflow:
```
1. In model.k, cursor on *INCLUDE for all_mesh.k
2. Press gf - opens all_mesh.k
3. Cursor on *INCLUDE for nodes.k
4. Press gf - opens nodes.k (relative to all_mesh.k location)
5. Use gt/gT to navigate between all open files
```

### Example 4: Using Splits for Comparison

```
1. Open main file: vim model.k
2. Cursor on first *INCLUDE
3. Press <C-w>f - opens in horizontal split
4. Now you can see both files simultaneously
5. Use <C-w>w to switch between windows
```

## File Path Resolution

The plugin searches for include files in this order:

1. **Absolute path**: If the path starts with `/`, uses it directly
2. **Relative to current file**: Searches relative to the directory of the current file
3. **Current directory**: Searches in Vim's current working directory

### Examples:

```lsdyna
*INCLUDE
materials.k
```
Searches for: `<current_file_directory>/materials.k`

```lsdyna
*INCLUDE
../includes/materials.k
```
Searches for: `<current_file_directory>/../includes/materials.k`

```lsdyna
*INCLUDE
/absolute/path/to/materials.k
```
Uses: `/absolute/path/to/materials.k` directly

## Tips and Tricks

### Quick Navigation Workflow

```vim
" Open main file
vim model.k

" Use gf to open includes
" Use gt/gT to switch between tabs
" Use :ls to see all buffers
" Use :tabs to see all tabs
```

### View All Open Files

```vim
:tabs       " List all tabs
:ls         " List all buffers
:files      " Same as :ls
```

### Close Multiple Tabs

```vim
:tabclose   " Close current tab
:tabo       " Close all tabs except current
:qa         " Quit all (prompts if unsaved changes)
```

### Split View for Comparison

```vim
" Open main file
vim model.k

" Open include in vertical split
:vsplit
<C-w>gf

" Or open in horizontal split
:split
<C-w>f

" Resize splits
<C-w>+    " Increase height
<C-w>-    " Decrease height
<C-w>>    " Increase width
<C-w><    " Decrease width
<C-w>=    " Equal size
```

### Working with Many Includes

For models with many includes:

```vim
" Open main file with all includes folded
vim model.k
zM

" Navigate to INCLUDE sections
/INCLUDE

" Open each include
gf

" View tab structure
:tabs

" Close unnecessary tabs
:tabc
```

## Configuration

### Custom Key Mappings

Add to your `~/.vimrc` to customize:

```vim
" Use Enter to open includes in new tab
autocmd FileType lsdyna nnoremap <buffer> <CR> :call LSDynaOpenInclude()<CR>

" Use Shift-Enter for split
autocmd FileType lsdyna nnoremap <buffer> <S-CR> :call LSDynaOpenIncludeSplit()<CR>

" Double-click to open (if using gvim)
autocmd FileType lsdyna nnoremap <buffer> <2-LeftMouse> :call LSDynaOpenInclude()<CR>
```

### Set Default Include Path

If your includes are always in a specific directory:

```vim
" Add to ~/.vimrc
autocmd FileType lsdyna set path+=./includes
autocmd FileType lsdyna set path+=../includes
```

## Troubleshooting

### File Not Found

If you see "File not found" error:

1. Check the filename in the INCLUDE line
2. Verify the file exists relative to the current file
3. Check for typos in the path
4. Use absolute path if needed

```vim
" Check current file location
:pwd
:echo expand('%:p:h')
```

### Wrong File Opens

If the wrong file opens:

1. Ensure cursor is on the `*INCLUDE` line, not on the filename line
2. Check for multiple files with similar names
3. Verify the relative path is correct

### Quotes in Filenames

The plugin automatically removes quotes:
```lsdyna
*INCLUDE "file.k"    → opens file.k
*INCLUDE 'file.k'    → opens file.k
```

## Advanced Usage

### Opening All Includes at Once

Create a Vim script to open all includes:

```vim
" Add to ~/.vimrc
function! OpenAllIncludes()
  let save_cursor = getcurpos()
  normal! gg
  while search('^\*INCLUDE', 'W') > 0
    call LSDynaOpenInclude()
  endwhile
  call setpos('.', save_cursor)
endfunction

" Map to <leader>oa (Open All)
autocmd FileType lsdyna nnoremap <buffer> <leader>oa :call OpenAllIncludes()<CR>
```

### List All Includes

```vim
" Show all INCLUDE lines
:g/^\*INCLUDE/p

" Show with line numbers
:g/^\*INCLUDE/#
```

### Search Across Includes

```vim
" Search in all open buffers
:bufdo vimgrep /pattern/ %

" Search in specific files
:vimgrep /pattern/ *.k
```

## Integration with Other Features

### Combined with Folding

```vim
zM              " Fold all
/INCLUDE        " Search for INCLUDE
za              " Open that fold
gf              " Open the include file
```

### Combined with Completion

```vim
" In the include file
lsd<C-x><C-o>   " Use completion
" Add new cards
:w              " Save
gt              " Return to main file
```

## Summary

The INCLUDE navigation feature provides:
- Quick access to included files with `gf`
- Opening in tabs or splits
- Intelligent path resolution
- Standard Vim navigation commands
- Integration with folding and other features

This dramatically improves workflow when working with multi-file LS-DYNA models, allowing seamless navigation between the main deck and all included files.

## Quick Reference Card

```
OPENING INCLUDES:
  gf          Open in new tab
  <C-w>f      Open in horizontal split
  <C-w>gf     Open in new tab (alternative)
  <leader>oi  Open in new tab (mnemonic: Open Include)
  <leader>os  Open in split (mnemonic: Open Split)

NAVIGATING TABS:
  gt          Next tab
  gT          Previous tab
  2gt         Go to tab 2
  :tabc       Close current tab
  :tabo       Close all other tabs

NAVIGATING SPLITS:
  <C-w>w      Next window
  <C-w>h/j/k/l  Move to window
  <C-w>q      Close window
  <C-w>=      Equal sizes