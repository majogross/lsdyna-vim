# LS-DYNA Vim Plugin - Code Folding Guide

The LS-DYNA Vim plugin includes intelligent code folding that helps you navigate and manage large input files efficiently by collapsing keyword sections.

## What is Code Folding?

Code folding allows you to collapse sections of your LS-DYNA input file, hiding the details while showing only the keyword headers. This makes it much easier to:
- Navigate large files with hundreds or thousands of lines
- Get an overview of the file structure
- Focus on specific sections without distraction
- Quickly jump between different cards

## How It Works

The plugin automatically detects LS-DYNA keywords (lines starting with `*`) and creates foldable sections. Each section includes:
- The keyword line (e.g., `*NODE`, `*ELEMENT_SOLID`, `*MAT_ELASTIC`)
- All data lines following that keyword
- Comment lines within the section

When folded, each section displays:
- The keyword name
- A preview of the first data line
- The total number of lines in the fold

## Folding Commands

The plugin uses standard Vim folding commands, so if you're already familiar with Vim folding, you can use your existing knowledge.

### Basic Commands

| Command | Description |
|---------|-------------|
| `zm` | Fold more - close one more level of folds |
| `zr` | Reduce folds - open one more level of folds |
| `zM` | Close all folds in the file |
| `zR` | Open all folds in the file |
| `za` | Toggle the fold under cursor (open if closed, close if open) |
| `zo` | Open the fold under cursor |
| `zc` | Close the fold under cursor |
| `zO` | Open all folds under cursor recursively |
| `zC` | Close all folds under cursor recursively |

### Navigation Commands

| Command | Description |
|---------|-------------|
| `zj` | Move cursor to next fold |
| `zk` | Move cursor to previous fold |
| `[z` | Move to start of current open fold |
| `]z` | Move to end of current open fold |

## Typical Workflows

### Workflow 1: Overview and Navigate

When opening a large LS-DYNA file:

```vim
1. Open your file: vim model.k
2. Close all folds: zM
3. Navigate through keywords using j/k
4. Open a specific section: za
5. Edit as needed
6. Close section when done: za
```

### Workflow 2: Selective Editing

When you need to edit specific sections:

```vim
1. Open file with all folds closed: vim model.k (then zM)
2. Search for keyword: /MATERIAL
3. Open that fold: za
4. Make your edits
5. Close and move to next: za, then /ELEMENT
6. Repeat as needed
```

### Workflow 3: Gradual Unfold

When exploring a new file:

```vim
1. Start with all closed: zM
2. Gradually open levels: zr
3. Continue opening: zr (repeat)
4. Close back one level: zm
5. Close everything: zM
```

## Fold Display Format

When a section is folded, you'll see something like:

```
*NODE | 1    0.0    0.0    0.0 ........................... [45 lines]
*ELEMENT_SOLID | 1    1    1    2    3 ..................... [1250 lines]
*MAT_ELASTIC | 1  7850.0  2.1E11  0.3 ....................... [3 lines]
```

This shows:
- The keyword (`*NODE`, `*ELEMENT_SOLID`, etc.)
- A preview of the first data line
- Dots filling the space
- Number of lines in the fold

## Configuration

### Default Settings

The plugin sets these folding options automatically:
- `foldmethod=expr` - Uses expression-based folding
- `foldlevel=0` - All folds closed by default
- `foldcolumn=2` - Shows 2-column fold indicator on left
- `foldnestmax=3` - Maximum fold nesting level

### Customizing Fold Behavior

Add these to your `~/.vimrc` to customize:

```vim
" Start with folds open
autocmd FileType lsdyna setlocal foldlevel=99

" Disable fold column (no visual indicator)
autocmd FileType lsdyna setlocal foldcolumn=0

" Always open folds when opening a file
autocmd FileType lsdyna normal zR
```

### Custom Key Mappings

If you prefer different keys, add to `~/.vimrc`:

```vim
" Map Space to toggle fold
autocmd FileType lsdyna nnoremap <buffer> <Space> za

" Map F2 to close all folds
autocmd FileType lsdyna nnoremap <buffer> <F2> zM

" Map F3 to open all folds
autocmd FileType lsdyna nnoremap <buffer> <F3> zR
```

## Tips and Tricks

### Quick Overview of File Structure

```vim
:e model.k
zM          " Close all folds
:g/^\*/     " Show all keyword lines
```

### Open Multiple Sections

Use visual mode to open several folds at once:
```vim
zM          " Close all
V           " Visual line mode
5j          " Select 5 lines
zO          " Open all folds in selection
```

### Fold Specific Keywords Only

You can manually fold just certain sections:
```vim
zR          " Open everything
/CONTACT    " Find CONTACT keywords
zf]/CONTACT " Fold from here to next CONTACT
```

### Save Fold State

Vim can remember your fold state between sessions:

Add to `~/.vimrc`:
```vim
autocmd BufWinLeave *.k,*.key mkview
autocmd BufWinEnter *.k,*.key silent! loadview
```

## Troubleshooting

### Folds Not Working

Check if folding is enabled:
```vim
:set foldmethod?    " Should show 'expr'
:set foldenable?    " Should show 'foldenable'
```

Enable if needed:
```vim
:set foldenable
:set foldmethod=expr
```

### Folds Behaving Strangely

Reset folding:
```vim
:setlocal foldmethod=expr
:setlocal foldexpr=LSDynaFoldLevel(v:lnum)
```

### All Folds Open by Default

Set fold level:
```vim
:setlocal foldlevel=0
```

Or close all manually:
```vim
zM
```

## Examples

### Example 1: Large Model with Many Materials

```
Before (opened):
*KEYWORD
*NODE
1    0.0    0.0    0.0
2    1.0    0.0    0.0
...
[thousands of lines]
*MAT_ELASTIC
1  7850.0  2.1E11  0.3
*MAT_PLASTIC_KINEMATIC
2  7850.0  2.1E11  0.3  300.0  0.0
...

After pressing zM:
*KEYWORD | *KEYWORD ............................... [1 lines]
*NODE | 1    0.0    0.0    0.0 ..................... [5234 lines]
*MAT_ELASTIC | 1  7850.0  2.1E11  0.3 .............. [3 lines]
*MAT_PLASTIC_KINEMATIC | 2  7850.0  2.1E11 ......... [4 lines]
```

### Example 2: Editing Specific Material

```
1. Open file and fold all: vim model.k, then zM
2. Search for material: /MAT_ELASTIC
3. Open that section: za
4. Edit properties
5. Close and save: za, then :w
```

## Integration with Other Features

### Combined with Search

```vim
zM              " Close all
/ELEMENT_SOLID  " Search
za              " Open found section
n               " Next match
za              " Open next section
```

### Combined with Completion

```vim
za              " Open a fold
lsd<C-x><C-o>   " Use completion menu
                " Select and insert new card
za              " Close fold
```

## Performance

The folding function is optimized for large files:
- Processes line-by-line efficiently
- No scanning of entire file
- Fast fold updates during editing

Tested successfully on files with:
- 100,000+ lines
- 1000+ keyword sections
- Mixed data types

## Summary

Code folding in the LS-DYNA Vim plugin provides:
- Automatic detection of keyword sections
- Standard Vim folding commands
- Custom fold text with previews
- Efficient navigation of large files
- No performance impact

Use `zm`, `zr`, `zM`, `zR`, and `za` to control folds and dramatically improve your workflow with large LS-DYNA input files.