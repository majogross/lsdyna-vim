# Quick Installation Guide

## Automatic Installation (Recommended)

The easiest way to install the LS-DYNA Vim plugin is to use the provided installation script:

```bash
cd /proj/cae_muc/q667207/70_scripts
./install.sh
```

This script will:
1. Create the necessary Vim directories in your home folder
2. Copy the syntax file to ~/.vim/syntax/
3. Copy the filetype detection to ~/.vim/ftdetect/
4. Detect and install snippets if UltiSnips or SnipMate is installed

## Manual Installation

If you prefer to install manually:

### Step 1: Install Syntax Highlighting

```bash
# Create directories
mkdir -p ~/.vim/syntax
mkdir -p ~/.vim/ftdetect

# Copy files
cp lsdyna.vim ~/.vim/syntax/
cp lsdyna_ftdetect.vim ~/.vim/ftdetect/lsdyna.vim
```

### Step 2: Install Snippets (Optional)

If you have UltiSnips:
```bash
mkdir -p ~/.vim/UltiSnips
cp lsdyna.snippets ~/.vim/UltiSnips/
```

If you have SnipMate:
```bash
mkdir -p ~/.vim/snippets
cp lsdyna.snippets ~/.vim/snippets/
```

### Step 3: Install Snippet Engine (if not already installed)

If you want to use code snippets, you need a snippet engine. Choose one:

**UltiSnips** (recommended):
Add to your ~/.vimrc:
```vim
" Using vim-plug
Plug 'SirVer/ultisnips'
```

**SnipMate**:
Add to your ~/.vimrc:
```vim
" Using vim-plug
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
```

Then run `:PlugInstall` in Vim.

## Verification

To verify the installation:

1. Create a test file:
   ```bash
   vim test.k
   ```

2. Type some LS-DYNA content:
   ```
   *KEYWORD
   *NODE
   1    0.0    0.0    0.0
   *END
   ```

3. You should see syntax highlighting applied automatically

4. To test snippets, type `node` and press Tab - a NODE card template should expand

## Troubleshooting

### Syntax highlighting not working

Check that the filetype is set correctly:
```vim
:set filetype?
```

It should show `filetype=lsdyna`. If not, manually set it:
```vim
:set filetype=lsdyna
```

### Snippets not working

1. Verify your snippet engine is installed:
   ```vim
   :scriptnames
   ```
   Look for "ultisnips" or "snipmate" in the list

2. Check that the snippets file is in the correct location:
   ```bash
   ls -la ~/.vim/UltiSnips/lsdyna.snippets
   # or
   ls -la ~/.vim/snippets/lsdyna.snippets
   ```

3. Make sure filetype is set to lsdyna:
   ```vim
   :set filetype=lsdyna
   ```

## System Information

Current system: Linux 4.18
Shell: /bin/tcsh
Home directory: /home/q667207

The installation script has been tested on your system configuration.

## Need Help?

For more detailed information, see the complete documentation in LSDYNA_VIM_README.md