# LS-DYNA Vim Plugin

A comprehensive Vim plugin for LS-DYNA input files, providing syntax highlighting, intelligent completion, abbreviations, and code snippets. Designed to streamline the creation and editing of LS-DYNA finite element analysis input files.

## Features

### Syntax Highlighting
- Color-coded highlighting for LS-DYNA keywords, comments, and numbers
- Automatic detection of LS-DYNA file types (.k, .key, .dyn, .inc)
- Support for scientific notation and all standard LS-DYNA card types
- Customizable colors that adapt to your Vim color scheme

### Intelligent Completion Menu
- Dropdown menu with 40+ card templates
- Type `lsd` and press `Ctrl-X Ctrl-O` to see all available templates
- Descriptive hints for each card type
- Quick discovery of available abbreviations

### Abbreviations System
- 43 built-in abbreviations for common LS-DYNA cards
- Expand templates by typing abbreviation + Space
- Includes field headers for easy data entry
- Covers elements, materials, contacts, controls, and more

### Code Snippets
- Compatible with UltiSnips and SnipMate
- Tab-triggered templates with field navigation
- Properly formatted according to LS-DYNA conventions
- Over 40 ready-to-use templates

### Additional Features
- Context-sensitive help system
- Automatic filetype detection
- Works with standard Vim without additional dependencies
- Tested on Linux systems

## Installation

### Quick Install (Recommended)

```bash
git clone https://github.com/YOUR_USERNAME/lsdyna-vim.git
cd lsdyna-vim
./install.sh
```

The installation script will automatically:
- Create necessary Vim directories
- Copy syntax and filetype detection files
- Install snippets if UltiSnips or SnipMate is detected
- Configure your Vim environment

### Manual Installation

1. Create Vim directories:
```bash
mkdir -p ~/.vim/syntax
mkdir -p ~/.vim/ftdetect
```

2. Copy core files:
```bash
cp lsdyna.vim ~/.vim/syntax/
cp lsdyna_ftdetect.vim ~/.vim/ftdetect/lsdyna.vim
cp lsdyna_abbrev.vim ~/.vim/ftplugin/lsdyna_abbrev.vim
cp lsdyna_complete.vim ~/.vim/autoload/lsdyna_complete.vim
cp lsdyna_help.vim ~/.vim/ftplugin/lsdyna_help.vim
```

3. Install snippets (optional):

For UltiSnips:
```bash
mkdir -p ~/.vim/UltiSnips
cp lsdyna.snippets ~/.vim/UltiSnips/
```

For SnipMate:
```bash
mkdir -p ~/.vim/snippets
cp lsdyna.snippets ~/.vim/snippets/
```

### Using Plugin Managers

#### vim-plug
Add to your `~/.vimrc`:
```vim
Plug 'YOUR_USERNAME/lsdyna-vim'
```

#### Vundle
Add to your `~/.vimrc`:
```vim
Plugin 'YOUR_USERNAME/lsdyna-vim'
```

#### Pathogen
```bash
cd ~/.vim/bundle
git clone https://github.com/YOUR_USERNAME/lsdyna-vim.git
```

## Quick Start

### Using the Completion Menu (Recommended)

1. Open a .k file in Vim
2. Type `lsd` in INSERT mode
3. Press `Ctrl-X` then `Ctrl-O` (omni-completion)
4. Select from the dropdown menu using arrow keys
5. Press Enter to insert, then Space to expand

### Using Direct Abbreviations

Simply type the abbreviation and press Space:

```
lsdnode<Space>        -> NODE card template
lsdmatelastic<Space>  -> MAT_ELASTIC card template
lsdelsolid<Space>     -> ELEMENT_SOLID card template
```

### Using Tab Snippets

With UltiSnips or SnipMate installed:

```
node<Tab>       -> NODE card with tab stops
matelastic<Tab> -> MAT_ELASTIC card with tab stops
```

## Available Card Templates

### Basic Structure
- `lsdkeyword` - Complete file with KEYWORD, TITLE, END
- `lsdtitle` - TITLE card
- `lsdcomment` - Comment block
- `lsdend` - END keyword

### Elements & Nodes
- `lsdnode` - NODE definition
- `lsdelsolid` - ELEMENT_SOLID
- `lsdelshell` - ELEMENT_SHELL
- `lsdelbeam` - ELEMENT_BEAM

### Materials
- `lsdmatelastic` - MAT_ELASTIC
- `lsdmatpwl` - MAT_PIECEWISE_LINEAR_PLASTICITY
- `lsdmatrigid` - MAT_RIGID
- `lsdmatjc` - MAT_JOHNSON_COOK

### Contact Definitions
- `lsdcontactss` - CONTACT_AUTOMATIC_SURFACE_TO_SURFACE
- `lsdcontactauto` - CONTACT_AUTOMATIC_SINGLE_SURFACE

### Control Cards
- `lsdcontrolterm` - CONTROL_TERMINATION
- `lsdcontroltime` - CONTROL_TIMESTEP
- `lsdcontrolenergy` - CONTROL_ENERGY
- `lsdcontrolhg` - CONTROL_HOURGLASS

### Database Output
- `lsdd3plot` - DATABASE_BINARY_D3PLOT
- `lsddbglstat` - DATABASE_GLSTAT
- `lsddbnodout` - DATABASE_NODOUT
- `lsddbelout` - DATABASE_ELOUT

For a complete list of 40+ templates, see [ABBREVIATIONS_GUIDE.md](ABBREVIATIONS_GUIDE.md)

## Documentation

- [Complete Usage Guide](USAGE_GUIDE.md) - Detailed usage instructions and workflow examples
- [Installation Guide](INSTALL.md) - Step-by-step installation instructions
- [Abbreviations Guide](ABBREVIATIONS_GUIDE.md) - Complete list of all abbreviations
- [Technical Documentation](LSDYNA_VIM_README.md) - Syntax highlighting details and customization

## Supported File Extensions

The plugin automatically activates for:
- `.k` - Standard LS-DYNA input files
- `.key` - Alternative extension
- `.dyn` - Dynamic files
- `.inc` - Include files
- `.k.*` - Versioned files (e.g., .k.01, .k.backup)
- `.key.*` - Versioned key files
- Files starting with `*KEYWORD`

## Usage Example

```
*KEYWORD
$  Example LS-DYNA input file
*TITLE
Example Model
$---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
*NODE
$     nid               x               y               z
        1             0.0             0.0             0.0
*ELEMENT_SOLID
$     eid     pid      n1      n2      n3      n4      n5      n6      n7      n8
        1       1       1       2       3       4       5       6       7       8
*MAT_ELASTIC
$     mid      ro       e      pr
        1  7850.0  2.1E11     0.3
*END
```

## Requirements

- Vim 7.0 or higher
- Linux, macOS, or Unix-like system (tested on Linux 4.18)
- Optional: UltiSnips or SnipMate for advanced snippet features

## Verification

Test the installation:

```bash
vim test.k
```

Type the following content:
```
*KEYWORD
*NODE
1    0.0    0.0    0.0
*END
```

You should see syntax highlighting automatically applied. Test completion by typing `lsd` and pressing `Ctrl-X Ctrl-O`.

## Troubleshooting

### Syntax highlighting not working

Check filetype:
```vim
:set filetype?
```

Should show `filetype=lsdyna`. If not:
```vim
:set filetype=lsdyna
```

### Completion menu not appearing

Verify omni-completion is set:
```vim
:set omnifunc?
```

Should show `omnifunc=LSDynaComplete`

### Abbreviations not expanding

1. Verify filetype is set to lsdyna
2. Check abbreviations are loaded: `:iabbrev`
3. Make sure you press Space or Enter after typing

For more troubleshooting help, see [USAGE_GUIDE.md](USAGE_GUIDE.md)

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-card-template`)
3. Commit your changes (`git commit -am 'Add new card template'`)
4. Push to the branch (`git push origin feature/new-card-template`)
5. Create a Pull Request

### Areas for Contribution

- Additional card templates
- Support for more LS-DYNA keywords
- Documentation improvements
- Bug fixes
- Color scheme enhancements

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Developed for the LS-DYNA finite element analysis community
- Inspired by the need for efficient LS-DYNA input file creation
- Thanks to all contributors and users

## Author

Created and maintained for streamlining LS-DYNA workflow in Vim.

## Support

For questions, issues, or feature requests:
- Open an issue on GitHub
- Check the documentation files in this repository
- Review the troubleshooting section above

## Version History

- v1.0.0 - Initial release with syntax highlighting, completion, abbreviations, and snippets

---

Made with care for the LS-DYNA community