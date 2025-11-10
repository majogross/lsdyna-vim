#!/bin/bash
# Installation script for LS-DYNA Vim syntax highlighter and snippets
# This script will install the files to the appropriate Vim directories

set -e

echo "LS-DYNA Vim Plugin Installer"
echo "============================="
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set installation directories
VIM_DIR="${HOME}/.vim"
SYNTAX_DIR="${VIM_DIR}/syntax"
FTDETECT_DIR="${VIM_DIR}/ftdetect"
ULTISNIPS_DIR="${VIM_DIR}/UltiSnips"
SNIPMATE_DIR="${VIM_DIR}/snippets"
FTPLUGIN_DIR="${VIM_DIR}/after/ftplugin"

# Create directories if they don't exist
echo "Creating Vim directories..."
mkdir -p "${SYNTAX_DIR}"
mkdir -p "${FTDETECT_DIR}"
mkdir -p "${FTPLUGIN_DIR}"

# Install syntax file
echo "Installing syntax file..."
if [ -f "${SCRIPT_DIR}/lsdyna.vim" ]; then
    cp "${SCRIPT_DIR}/lsdyna.vim" "${SYNTAX_DIR}/"
    echo "  - Installed lsdyna.vim to ${SYNTAX_DIR}/"
else
    echo "  ERROR: lsdyna.vim not found in ${SCRIPT_DIR}"
    exit 1
fi

# Install filetype detection
echo "Installing filetype detection..."
if [ -f "${SCRIPT_DIR}/lsdyna_ftdetect.vim" ]; then
    cp "${SCRIPT_DIR}/lsdyna_ftdetect.vim" "${FTDETECT_DIR}/lsdyna.vim"
    echo "  - Installed lsdyna_ftdetect.vim to ${FTDETECT_DIR}/lsdyna.vim"
else
    echo "  ERROR: lsdyna_ftdetect.vim not found in ${SCRIPT_DIR}"
    exit 1
fi

# Install ftplugin file (includes folding support)
echo "Installing ftplugin (folding support)..."
if [ -f "${SCRIPT_DIR}/ftplugin/lsdyna.vim" ]; then
    mkdir -p "${FTPLUGIN_DIR}"
    cp "${SCRIPT_DIR}/ftplugin/lsdyna.vim" "${FTPLUGIN_DIR}/"
    echo "  - Installed ftplugin/lsdyna.vim to ${FTPLUGIN_DIR}/"
else
    echo "  WARNING: ftplugin/lsdyna.vim not found in ${SCRIPT_DIR}"
fi

# Install completion file
echo "Installing completion support..."
if [ -f "${SCRIPT_DIR}/lsdyna_complete.vim" ]; then
    cp "${SCRIPT_DIR}/lsdyna_complete.vim" "${FTPLUGIN_DIR}/"
    echo "  - Installed lsdyna_complete.vim to ${FTPLUGIN_DIR}/"
else
    echo "  WARNING: lsdyna_complete.vim not found in ${SCRIPT_DIR}"
fi

# Install help system
echo "Installing help system..."
if [ -f "${SCRIPT_DIR}/lsdyna_help.vim" ]; then
    cp "${SCRIPT_DIR}/lsdyna_help.vim" "${FTPLUGIN_DIR}/"
    echo "  - Installed lsdyna_help.vim to ${FTPLUGIN_DIR}/"
else
    echo "  WARNING: lsdyna_help.vim not found in ${SCRIPT_DIR}"
fi

# Check for snippet engines and install accordingly
SNIPPET_INSTALLED=false

if [ -f "${SCRIPT_DIR}/lsdyna.snippets" ]; then
    # Check for UltiSnips
    if vim --version 2>/dev/null | grep -q "VIM" && [ -d "${HOME}/.vim/plugged/ultisnips" -o -d "${HOME}/.vim/bundle/ultisnips" ]; then
        echo "UltiSnips detected. Installing snippets for UltiSnips..."
        mkdir -p "${ULTISNIPS_DIR}"
        cp "${SCRIPT_DIR}/lsdyna.snippets" "${ULTISNIPS_DIR}/"
        echo "  - Installed lsdyna.snippets to ${ULTISNIPS_DIR}/"
        SNIPPET_INSTALLED=true
    fi
    
    # Check for SnipMate
    if vim --version 2>/dev/null | grep -q "VIM" && [ -d "${HOME}/.vim/plugged/vim-snipmate" -o -d "${HOME}/.vim/bundle/vim-snipmate" ]; then
        echo "SnipMate detected. Installing snippets for SnipMate..."
        mkdir -p "${SNIPMATE_DIR}"
        cp "${SCRIPT_DIR}/lsdyna.snippets" "${SNIPMATE_DIR}/"
        echo "  - Installed lsdyna.snippets to ${SNIPMATE_DIR}/"
        SNIPPET_INSTALLED=true
    fi
    
    if [ "$SNIPPET_INSTALLED" = false ]; then
        echo "No snippet engine detected."
        echo ""
        echo "Installing abbreviations file as alternative..."
        if [ -f "${SCRIPT_DIR}/lsdyna_abbrev.vim" ]; then
            cp "${SCRIPT_DIR}/lsdyna_abbrev.vim" "${FTPLUGIN_DIR}/"
            echo "  - Installed lsdyna_abbrev.vim to ${FTPLUGIN_DIR}/"
            echo ""
            echo "Abbreviations installed successfully!"
            echo "These work without requiring a snippet engine."
        else
            echo "  WARNING: lsdyna_abbrev.vim not found"
            echo ""
            echo "If you want to use code templates, you can:"
            echo "  1. Install a snippet engine (UltiSnips or SnipMate)"
            echo "  2. Then manually copy lsdyna.snippets to:"
            echo "     - For UltiSnips: ${ULTISNIPS_DIR}/"
            echo "     - For SnipMate: ${SNIPMATE_DIR}/"
        fi
    fi
else
    echo "  WARNING: lsdyna.snippets not found in ${SCRIPT_DIR}"
fi

echo ""
echo "Installation complete!"
echo ""
echo "The LS-DYNA syntax highlighter has been installed."
echo "It will automatically activate for files with extensions:"
echo "  .k, .key, .dyn, .inc"
echo ""

if [ "$SNIPPET_INSTALLED" = true ]; then
    echo "Snippets have been installed. Use them by typing:"
    echo "  node<Tab>           - Insert NODE card"
    echo "  elsolid<Tab>        - Insert ELEMENT_SOLID card"
    echo "  matelastic<Tab>     - Insert MAT_ELASTIC card"
    echo "  And many more..."
    echo ""
elif [ -f "${FTPLUGIN_DIR}/lsdyna_abbrev.vim" ]; then
    echo "Abbreviations have been installed. Use them by typing:"
    echo "  lsdnode<Space>      - Insert NODE card"
    echo "  lsdelsolid<Space>   - Insert ELEMENT_SOLID card"
    echo "  lsdmatelastic<Space> - Insert MAT_ELASTIC card"
    echo "  And many more (use 'lsd' prefix)"
    echo ""
    echo "NOTE: Abbreviations expand when you press Space or Enter,"
    echo "      not Tab like snippets."
    echo ""
fi

if [ -f "${FTPLUGIN_DIR}/lsdyna_complete.vim" ]; then
    echo "Completion menu has been installed!"
    echo "  Type 'lsd' then press Ctrl-X Ctrl-O to see dropdown menu"
    echo "  Or press Ctrl-Space for quick access"
    echo ""

if [ -f "${FTPLUGIN_DIR}/lsdyna.vim" ]; then
    echo "Code folding has been installed!"
    echo "  Standard Vim folding commands work:"
    echo "    zm  - Fold more (close one fold level)"
    echo "    zr  - Fold less (open one fold level)"
    echo "    zM  - Close all folds"
    echo "    zR  - Open all folds"
    echo "    za  - Toggle fold under cursor"
    echo ""
fi
fi

if [ -f "${FTPLUGIN_DIR}/lsdyna_help.vim" ]; then
    echo "Help system has been installed!"
    echo "  Press 'K' (Shift-k) when cursor is on a keyword line"
    echo "  Shows field descriptions for 15+ material models and keywords"
    echo ""
fi

echo "To test the installation, open a .k file in Vim:"
echo "  vim test.k"
echo ""
echo "For more information, see LSDYNA_VIM_README.md"