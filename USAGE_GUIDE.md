# LS-DYNA Vim Plugin - Complete Usage Guide

This guide covers all features of the LS-DYNA Vim plugin including syntax highlighting, abbreviations, completion menu, and snippets.

## Quick Start

After installation, you have THREE ways to insert LS-DYNA card templates:

### Method 1: Dropdown Completion Menu (RECOMMENDED)

This is the easiest method to discover available templates.

**How to use:**
1. Open a .k file in Vim
2. In INSERT mode, type `lsd`
3. Press `Ctrl-X` then `Ctrl-O` (omni-completion)
4. A dropdown menu appears showing all available templates with descriptions
5. Use arrow keys to select, press Enter to insert
6. Then press Space to expand the abbreviation

**Quick access:**
- Press `Ctrl-Space` instead of `Ctrl-X Ctrl-O` for faster access

**Example:**
```
Type: lsd
Press: Ctrl-X Ctrl-O
Select: lsdnode (Node definition)
Press: Enter
Press: Space
Result: Full NODE card appears
```

### Method 2: Direct Abbreviations

If you know the abbreviation name, type it directly.

**How to use:**
1. Type the full abbreviation (e.g., `lsdnode`)
2. Press Space or Enter
3. Template expands

**Example:**
```
Type: lsdmatelastic<Space>
Result: Full MAT_ELASTIC card appears
```

### Method 3: Tab Snippets (Advanced)

Requires UltiSnips or SnipMate plugin.

**How to use:**
1. Type the trigger word (without 'lsd' prefix)
2. Press Tab
3. Use Tab to jump between fields

**Example:**
```
Type: node<Tab>
Result: NODE card with tab stops for easy editing
```

## Complete Feature List

### 1. Syntax Highlighting

Automatic color coding for:
- Keywords (lines starting with *)
- Comments (lines starting with $)
- Numbers (including scientific notation)
- Specific card types (ELEMENT, MAT, CONTACT, etc.)

**Works automatically** for files with extensions: .k, .key, .dyn, .inc

### 2. Completion Menu

Shows dropdown list of all available templates with descriptions.

**Trigger keys:**
- `Ctrl-X Ctrl-O` - Standard omni-completion
- `Ctrl-Space` - Quick shortcut

**Shows:**
- Abbreviation name
- Short description
- Card type information

### 3. Abbreviations

43 built-in abbreviations for common LS-DYNA cards.

**All abbreviations start with `lsd`:**

#### Basic Structure
- `lsdkeyword` - Complete file with KEYWORD, TITLE, END
- `lsdtitle` - TITLE card
- `lsdcomment` - Comment block
- `lsdend` - END keyword

#### Elements
- `lsdnode` - NODE card
- `lsdelsolid` - ELEMENT_SOLID
- `lsdelshell` - ELEMENT_SHELL
- `lsdelbeam` - ELEMENT_BEAM

#### Parts and Sections
- `lsdpart` - PART
- `lsdsecshell` - SECTION_SHELL
- `lsdsecsolid` - SECTION_SOLID
- `lsdsecbeam` - SECTION_BEAM

#### Materials
- `lsdmatelastic` - MAT_ELASTIC
- `lsdmatpwl` - MAT_PIECEWISE_LINEAR_PLASTICITY
- `lsdmatrigid` - MAT_RIGID
- `lsdmatjc` - MAT_JOHNSON_COOK

#### Contact
- `lsdcontactss` - CONTACT_AUTOMATIC_SURFACE_TO_SURFACE
- `lsdcontactauto` - CONTACT_AUTOMATIC_SINGLE_SURFACE

#### Control Cards
- `lsdcontrolterm` - CONTROL_TERMINATION
- `lsdcontroltime` - CONTROL_TIMESTEP
- `lsdcontrolenergy` - CONTROL_ENERGY
- `lsdcontrolhg` - CONTROL_HOURGLASS
- `lsdcontrolshell` - CONTROL_SHELL
- `lsdcontrolsolid` - CONTROL_SOLID
- `lsdcontrolacc` - CONTROL_ACCURACY

#### Database Output
- `lsdd3plot` - DATABASE_BINARY_D3PLOT
- `lsddbglstat` - DATABASE_GLSTAT
- `lsddbnodout` - DATABASE_NODOUT
- `lsddbelout` - DATABASE_ELOUT

#### Define Cards
- `lsddefcurve` - DEFINE_CURVE
- `lsddeftable` - DEFINE_TABLE

#### Sets
- `lsdsetnodelist` - SET_NODE_LIST
- `lsdsetpartlist` - SET_PART_LIST
- `lsdsetsegment` - SET_SEGMENT

#### Boundary Conditions
- `lsdboundaryspc` - BOUNDARY_SPC_SET
- `lsdboundarypm` - BOUNDARY_PRESCRIBED_MOTION_SET

#### Loads
- `lsdloadnode` - LOAD_NODE_SET
- `lsdloadseg` - LOAD_SEGMENT_SET

#### Initial Conditions
- `lsdinitvel` - INITIAL_VELOCITY
- `lsdinitvelgen` - INITIAL_VELOCITY_GENERATION

#### Other
- `lsdinclude` - INCLUDE
- `lsdparameter` - PARAMETER

## Typical Workflow

### Creating a New LS-DYNA Model

```vim
1. Create file:
   vim mymodel.k

2. Start with structure:
   Type: lsd
   Press: Ctrl-X Ctrl-O
   Select: lsdkeyword
   Press: Enter, then Space

3. Add nodes:
   Type: lsd
   Press: Ctrl-X Ctrl-O
   Select: lsdnode
   Press: Enter, then Space
   Edit node coordinates

4. Add elements:
   Type: lsd
   Press: Ctrl-X Ctrl-O
   Select: lsdelsolid
   Press: Enter, then Space
   Edit element connectivity

5. Add material:
   Type: lsd
   Press: Ctrl-X Ctrl-O
   Select: lsdmatelastic
   Press: Enter, then Space
   Edit material properties

6. Add control cards:
   Type: lsd
   Press: Ctrl-X Ctrl-O
   Select: lsdcontrolterm
   Press: Enter, then Space
   Set end time

7. Continue adding required cards...
```

## Tips and Tricks

### 1. Quick Discovery
When you forget an abbreviation name:
- Type `lsd` and press `Ctrl-X Ctrl-O`
- Browse the menu to find what you need
- The description helps identify the right card

### 2. Muscle Memory
After using a few times, you'll remember common abbreviations:
- `lsdnode` for nodes
- `lsdelsolid` for solid elements
- `lsdmatelastic` for materials

### 3. Completion While Typing
You can press `Ctrl-X Ctrl-O` even after typing part of the name:
- Type: `lsdmat`
- Press: `Ctrl-X Ctrl-O`
- Only material abbreviations show up

### 4. Field Headers Included
All templates include LS-DYNA field headers (the $ comment lines), making it easy to know what each column represents.

### 5. Syntax Highlighting
Colors help verify structure:
- Keywords are highlighted
- Numbers are colored
- Comments are distinct

## Keyboard Reference

| Key Combination | Action |
|----------------|--------|
| `Ctrl-X Ctrl-O` | Open completion menu |
| `Ctrl-Space` | Quick completion menu |
| `Arrow Up/Down` | Navigate menu |
| `Enter` | Select from menu |
| `Space/Enter` | Expand abbreviation |
| `Esc` | Cancel menu |

## Troubleshooting

### Completion menu doesn't appear

1. Check filetype:
   ```vim
   :set filetype?
   ```
   Should show: `filetype=lsdyna`

2. Manually set if needed:
   ```vim
   :set filetype=lsdyna
   ```

3. Check if completion is loaded:
   ```vim
   :set omnifunc?
   ```
   Should show: `omnifunc=LSDynaComplete`

### Abbreviations don't expand

1. Verify filetype is set to lsdyna
2. Check abbreviations are loaded:
   ```vim
   :iabbrev
   ```
3. Make sure you press Space or Enter after typing

### Syntax highlighting not working

1. Check syntax is loaded:
   ```vim
   :syntax
   ```
2. Manually enable if needed:
   ```vim
   :syntax on
   ```

## Advanced Configuration

### Auto-trigger Completion

Add to ~/.vimrc to automatically show menu when typing 'lsd':

```vim
autocmd FileType lsdyna inoremap <buffer> <silent> <expr> d
  \ getline('.')[col('.')-3:col('.')-1] ==# 'lsd' ? "\<C-x>\<C-o>" : 'd'
```

### Custom Key Mapping

Change completion trigger to your preference:

```vim
autocmd FileType lsdyna inoremap <buffer> <C-k> <C-x><C-o>
```

### Disable Abbreviations

If you only want the completion menu without abbreviations:

```vim
let g:lsdyna_no_abbrev = 1
```

## Getting Help

For more information:
- See ABBREVIATIONS_GUIDE.md for abbreviation details
- See INSTALL.md for installation instructions
- See LSDYNA_VIM_README.md for complete documentation

## Summary

The LS-DYNA Vim plugin provides three complementary features:

1. **Syntax Highlighting** - Automatic, always on
2. **Completion Menu** - Press `Ctrl-X Ctrl-O` after typing `lsd`
3. **Abbreviations** - Type full name + Space

Use the completion menu when discovering, use abbreviations when you know the name.