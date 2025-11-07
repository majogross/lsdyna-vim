#!/bin/bash
# Script to check Vim configuration and snippet engine installation

echo "Checking Vim Setup for LS-DYNA Plugin"
echo "======================================"
echo ""

# Check if Vim is installed
if command -v vim >/dev/null 2>&1; then
    echo "Vim is installed:"
    vim --version | head -n 1
else
    echo "ERROR: Vim is not installed"
    exit 1
fi

echo ""
echo "Checking for snippet engines..."
echo ""

# Check for UltiSnips
if [ -d "$HOME/.vim/plugged/ultisnips" ] || [ -d "$HOME/.vim/bundle/ultisnips" ]; then
    echo "UltiSnips: FOUND"
    ULTISNIPS=true
else
    echo "UltiSnips: NOT FOUND"
    ULTISNIPS=false
fi

# Check for SnipMate
if [ -d "$HOME/.vim/plugged/vim-snipmate" ] || [ -d "$HOME/.vim/bundle/vim-snipmate" ]; then
    echo "SnipMate: FOUND"
    SNIPMATE=true
else
    echo "SnipMate: NOT FOUND"
    SNIPMATE=false
fi

echo ""
echo "Checking installed LS-DYNA files..."
echo ""

# Check syntax file
if [ -f "$HOME/.vim/syntax/lsdyna.vim" ]; then
    echo "Syntax file: INSTALLED at ~/.vim/syntax/lsdyna.vim"
else
    echo "Syntax file: NOT FOUND"
fi

# Check ftdetect file
if [ -f "$HOME/.vim/ftdetect/lsdyna.vim" ]; then
    echo "Filetype detection: INSTALLED at ~/.vim/ftdetect/lsdyna.vim"
else
    echo "Filetype detection: NOT FOUND"
fi

# Check snippets
if [ -f "$HOME/.vim/UltiSnips/lsdyna.snippets" ]; then
    echo "Snippets (UltiSnips): INSTALLED at ~/.vim/UltiSnips/lsdyna.snippets"
elif [ -f "$HOME/.vim/snippets/lsdyna.snippets" ]; then
    echo "Snippets (SnipMate): INSTALLED at ~/.vim/snippets/lsdyna.snippets"
else
    echo "Snippets: NOT FOUND"
fi

echo ""
echo "Checking .vimrc configuration..."
echo ""

if [ -f "$HOME/.vimrc" ]; then
    echo ".vimrc exists"
    if grep -q "ultisnips\|snipmate" "$HOME/.vimrc" 2>/dev/null; then
        echo "Snippet engine configuration found in .vimrc"
    else
        echo "No snippet engine configuration found in .vimrc"
    fi
else
    echo ".vimrc does not exist"
fi

echo ""
echo "================================"
echo "Summary:"
echo "================================"

if [ "$ULTISNIPS" = true ] || [ "$SNIPMATE" = true ]; then
    echo "You have a snippet engine installed."
    echo "Snippets should work after proper configuration."
else
    echo "No snippet engine detected."
    echo ""
    echo "RECOMMENDATION:"
    echo "Install UltiSnips for snippet support, or use the"
    echo "standalone abbreviations file (lsdyna_abbrev.vim) instead."
    echo ""
    echo "To check what's loaded in Vim, open Vim and type:"
    echo "  :scriptnames"
fi

echo ""