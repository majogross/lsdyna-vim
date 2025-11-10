# LS-DYNA INCLUDE Navigation Guide

## Overview

The LS-DYNA Vim plugin provides enhanced navigation for `*INCLUDE` files with automatic `*INCLUDE_PATH` resolution. When you navigate to an include file, the plugin intelligently searches multiple locations to find the file.

## File Path Resolution Strategy

When you navigate to an `*INCLUDE` file, the plugin tries the following locations in order:

1. **Direct path**: The exact path as specified in the INCLUDE line (maintains backward compatibility)
2. **Relative to current file**: The include path relative to the directory of the current file
3. **INCLUDE_PATH + filename**: Combines any `*INCLUDE_PATH` declarations with the include filename
4. **Current directory + INCLUDE_PATH + filename**: Combines the current file's directory with INCLUDE_PATH and filename

## How INCLUDE_PATH Works

### INCLUDE_PATH Declaration Format

```
*INCLUDE_PATH
/path/to/includes/
```

The path is specified on the line(s) immediately following the `*INCLUDE_PATH` keyword.

**Multiple Paths per INCLUDE_PATH:**
```
*INCLUDE_PATH
/path/to/parts/
/path/to/materials/
/path/to/contacts/
```

You can specify multiple paths after a single `*INCLUDE_PATH` keyword. The plugin will read all consecutive non-empty, non-comment lines as paths until it encounters another keyword, a comment line, or an empty line.

### Example LS-DYNA File Structure

**Example 1: Multiple INCLUDE_PATH Keywords**
```
*KEYWORD
$ Define base paths for include files
*INCLUDE_PATH
/project/models/parts/
*INCLUDE_PATH
./components/
$ Include files using relative paths
*INCLUDE
front_bumper.k
*INCLUDE
side_panel.k
```

In this example:
- `front_bumper.k` will be searched in `/project/models/parts/front_bumper.k`
- `side_panel.k` will be searched in `./components/side_panel.k`
- The plugin searches backward from the current INCLUDE to find all INCLUDE_PATH declarations

**Example 2: Multiple Paths in One INCLUDE_PATH**
```
*KEYWORD
$ Define multiple base paths in one declaration
*INCLUDE_PATH
/shared/materials/
/shared/parts/
/shared/contacts/
$ Include files will be searched in all paths above
*INCLUDE
steel_mat.k
*INCLUDE
chassis_part.k
```

In this example, both include files will be searched in all three paths:
- `steel_mat.k` is searched in `/shared/materials/`, `/shared/parts/`, `/shared/contacts/`
- `chassis_part.k` is searched in the same three paths

## Navigation Commands

### Basic Navigation

- **`gf`**: Open include file in new tab (cursor must be on `*INCLUDE` line)
- **`<C-w>f`**: Open include file in horizontal split
- **`<C-w>gf`**: Open include file in new tab (alternative)

### Custom Mappings

- **`<leader>oi`**: Open include file in new tab (works anywhere on the include line)
- **`<leader>os`**: Open include file in split (works anywhere on the include line)

## Usage Examples

### Example 1: Direct Path

```
*INCLUDE
/absolute/path/to/mesh.k
```

Position cursor on the `*INCLUDE` line and press `gf` to open `/absolute/path/to/mesh.k`

### Example 2: Relative Path

```
*INCLUDE
./parts/chassis.k
```

If the current file is in `/project/model/`, pressing `gf` opens `/project/model/parts/chassis.k`

### Example 3: INCLUDE_PATH Resolution

```
*INCLUDE_PATH
/shared/materials/
*INCLUDE
steel_properties.k
```

Pressing `gf` on the INCLUDE line will search for:
1. `steel_properties.k` (direct)
2. `./steel_properties.k` (relative to current file)
3. `/shared/materials/steel_properties.k` (INCLUDE_PATH + filename)

### Example 4: Multiple INCLUDE_PATH Declarations

```
*INCLUDE_PATH
/base/path/meshes/
*INCLUDE
part1.k
*INCLUDE_PATH
/base/path/contacts/
*INCLUDE
contact_definitions.k
```

The plugin searches backward from each INCLUDE to find all INCLUDE_PATH declarations:
- `part1.k` uses `/base/path/meshes/`
- `contact_definitions.k` uses both `/base/path/meshes/` and `/base/path/contacts/`

### Example 5: Combined Multiple Paths

```
*INCLUDE_PATH
/project/base/
/project/shared/
/fallback/path/
*INCLUDE
component.k
```

The plugin will search for `component.k` in:
1. `component.k` (direct)
2. `./component.k` (relative to current file)
3. `/project/base/component.k`
4. `/project/shared/component.k`
5. `/fallback/path/component.k`

## Features

- **Backward Compatibility**: Existing direct paths continue to work as before
- **Smart Search**: Automatically tries multiple locations to find the file
- **Multiple INCLUDE_PATH Support**: Handles multiple INCLUDE_PATH declarations in the same file
- **Quote Handling**: Automatically removes quotes from filenames
- **Error Messages**: Clear feedback when files cannot be found

## Implementation Details

The enhancement adds two helper functions:

1. **`s:FindIncludePaths()`**: Searches backward from the cursor to find all `*INCLUDE_PATH` declarations and reads all paths specified after each keyword (supports multiple paths per INCLUDE_PATH)
2. **`s:ResolveIncludePath(filename)`**: Tries multiple path combinations to locate the include file

Both `LSDynaOpenInclude()` and `LSDynaOpenIncludeSplit()` functions now use these helpers to resolve file paths intelligently.

### How Multiple Paths Are Read

When the plugin encounters an `*INCLUDE_PATH` keyword, it reads consecutive lines as paths until it hits:
- Another LS-DYNA keyword (line starting with `*`)
- A comment line (starting with `$`)
- An empty line
- The current cursor position

## Troubleshooting

### File Not Found Error

If you see "File not found: filename.k", the plugin searched all possible locations and couldn't find the file. Check:

1. The filename spelling in the INCLUDE line
2. The path specified in INCLUDE_PATH declarations
3. File permissions and existence on the filesystem

### No INCLUDE_PATH Found

If no `*INCLUDE_PATH` is found before the current INCLUDE, the plugin falls back to:
1. Direct path resolution
2. Relative to current file's directory

This ensures backward compatibility with files that don't use INCLUDE_PATH.

## Notes

- INCLUDE_PATH paths can be absolute or relative
- The plugin respects both forward slashes (/) and backslashes (\) as path separators
- Path resolution is performed at navigation time, not when the file is loaded
- The most recent INCLUDE_PATH before the current position is used for resolution