# LS-DYNA Vim Abbreviations Quick Reference

This guide explains how to use the abbreviations feature, which works WITHOUT requiring any snippet engine (UltiSnips or SnipMate). Abbreviations use Vim's built-in functionality.

## How Abbreviations Work

Unlike snippets that expand with Tab, abbreviations expand when you press **Space** or **Enter**.

## Installation

The abbreviations are automatically installed when you run:
```bash
./install.sh
```

The file will be placed at: `~/.vim/after/ftplugin/lsdyna_abbrev.vim`

## Usage

1. Open any LS-DYNA file (.k, .key, .dyn, .inc)
2. In INSERT mode, type an abbreviation keyword
3. Press **Space** or **Enter** to expand

**Example:**
```
Type: lsdnode<Space>
Result: Full NODE card template appears
```

## Complete Abbreviation List

All abbreviations start with the prefix `lsd` to avoid conflicts.

### Basic Structure
- `lsdkeyword` - Complete file structure with KEYWORD, TITLE, and END
- `lsdtitle` - TITLE card
- `lsdcomment` - Comment block
- `lsdend` - END keyword

### Elements
- `lsdnode` - NODE card
- `lsdelsolid` - ELEMENT_SOLID card
- `lsdelshell` - ELEMENT_SHELL card
- `lsdelbeam` - ELEMENT_BEAM card

### Parts and Sections
- `lsdpart` - PART card
- `lsdsecshell` - SECTION_SHELL card
- `lsdsecsolid` - SECTION_SOLID card
- `lsdsecbeam` - SECTION_BEAM card

### Materials
- `lsdmatelastic` - MAT_ELASTIC card
- `lsdmatpwl` - MAT_PIECEWISE_LINEAR_PLASTICITY card
- `lsdmatrigid` - MAT_RIGID card
- `lsdmatjc` - MAT_JOHNSON_COOK card

### Contact
- `lsdcontactss` - CONTACT_AUTOMATIC_SURFACE_TO_SURFACE
- `lsdcontactauto` - CONTACT_AUTOMATIC_SINGLE_SURFACE

### Control Cards
- `lsdcontrolterm` - CONTROL_TERMINATION
- `lsdcontroltime` - CONTROL_TIMESTEP
- `lsdcontrolenergy` - CONTROL_ENERGY
- `lsdcontrolhg` - CONTROL_HOURGLASS
- `lsdcontrolshell` - CONTROL_SHELL
- `lsdcontrolsolid` - CONTROL_SOLID
- `lsdcontrolacc` - CONTROL_ACCURACY

### Database Output
- `lsdd3plot` - DATABASE_BINARY_D3PLOT
- `lsddbglstat` - DATABASE_GLSTAT
- `lsddbnodout` - DATABASE_NODOUT
- `lsddbelout` - DATABASE_ELOUT

### Define Cards
- `lsddefcurve` - DEFINE_CURVE
- `lsddeftable` - DEFINE_TABLE

### Sets
- `lsdsetnodelist` - SET_NODE_LIST
- `lsdsetpartlist` - SET_PART_LIST
- `lsdsetsegment` - SET_SEGMENT

### Boundary Conditions
- `lsdboundaryspc` - BOUNDARY_SPC_SET
- `lsdboundarypm` - BOUNDARY_PRESCRIBED_MOTION_SET

### Loads
- `lsdloadnode` - LOAD_NODE_SET
- `lsdloadseg` - LOAD_SEGMENT_SET

### Initial Conditions
- `lsdinitvel` - INITIAL_VELOCITY
- `lsdinitvelgen` - INITIAL_VELOCITY_GENERATION

### Other
- `lsdinclude` - INCLUDE card
- `lsdparameter` - PARAMETER card

## Example Workflow

Creating a simple LS-DYNA input file:

```
1. Open Vim and create a new file:
   vim mymodel.k

2. Type the following (pressing Space after each):
   lsdkeyword<Space>

3. Add a node:
   lsdnode<Space>

4. Add an element:
   lsdelsolid<Space>

5. Add a material:
   lsdmatelastic<Space>
```

Each abbreviation will expand into a properly formatted card with field headers and placeholder values.

## Tips

1. **Remember the prefix**: All abbreviations start with `lsd`
2. **Press Space or Enter**: Unlike snippets, abbreviations need Space/Enter to expand, not Tab
3. **Works everywhere**: No special plugin required, works in plain Vim
4. **Case sensitive**: Use lowercase `lsd` prefix
5. **Edit after expansion**: After expansion, manually edit the values as needed

## Troubleshooting

### Abbreviations not working?

1. Check if the file is recognized as lsdyna type:
   ```vim
   :set filetype?
   ```
   Should show: `filetype=lsdyna`

2. If not, manually set it:
   ```vim
   :set filetype=lsdyna
   ```

3. Verify abbreviations are loaded:
   ```vim
   :iabbrev
   ```
   Should show list of lsd* abbreviations

### Manual loading

If abbreviations aren't loaded automatically:
```vim
:source ~/.vim/after/ftplugin/lsdyna_abbrev.vim
```

## Switching to Snippets

If you later decide to use snippets instead of abbreviations:

1. Install a snippet engine (UltiSnips recommended):
   ```vim
   " Add to ~/.vimrc
   Plug 'SirVer/ultisnips'
   ```

2. Run `:PlugInstall` in Vim

3. Copy the snippets file:
   ```bash
   cp lsdyna.snippets ~/.vim/UltiSnips/
   ```

4. Now you can use Tab instead of Space for expansion

## Comparison: Abbreviations vs Snippets

| Feature | Abbreviations | Snippets |
|---------|--------------|----------|
| Expansion key | Space/Enter | Tab |
| Plugin required | No | Yes (UltiSnips/SnipMate) |
| Tab stops | No | Yes |
| Setup complexity | Simple | Moderate |
| Works in plain Vim | Yes | No |

For quick and simple usage without setup, abbreviations are the best choice.