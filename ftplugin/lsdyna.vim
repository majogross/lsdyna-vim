" Vim ftplugin file
" Language: LS-DYNA input file
" Maintainer: Auto-generated
" Latest Revision: 2025

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Save the current 'cpoptions' value and set it to Vim default
let s:save_cpo = &cpo
set cpo&vim

" Enable folding based on LS-DYNA keywords
setlocal foldmethod=expr
setlocal foldexpr=LSDynaFoldLevel(v:lnum)
setlocal foldtext=LSDynaFoldText()

" Set fold options for better usability
setlocal foldlevel=0
setlocal foldcolumn=2
setlocal foldnestmax=3

" Function to determine fold level for each line
function! LSDynaFoldLevel(lnum)
  let line = getline(a:lnum)
  let next_line = getline(a:lnum + 1)
  
  " Start a new fold at any LS-DYNA keyword line (starts with *)
  if line =~? '^\*[A-Z_][A-Z0-9_]*'
    " Check if this is *END keyword - it should close all folds
    if line =~? '^\*END\s*$'
      return '0'
    endif
    
    " Check if next line is also a keyword (meaning this keyword has no data)
    if next_line =~? '^\*[A-Z_][A-Z0-9_]*'
      return '1'
    endif
    
    " Start a new fold at level 1
    return '>1'
  endif
  
  " Comment lines continue current fold level
  if line =~? '^\$'
    return '='
  endif
  
  " Empty lines continue current fold level
  if line =~? '^\s*$'
    return '='
  endif
  
  " Data lines continue current fold level
  return '='
endfunction

" Function to customize fold text display
function! LSDynaFoldText()
  let line = getline(v:foldstart)
  let lines_count = v:foldend - v:foldstart + 1
  
  " Extract the keyword name
  let keyword = matchstr(line, '^\*[A-Z_][A-Z0-9_]*')
  
  " Get the next non-comment, non-empty line for context
  let context = ""
  let lnum = v:foldstart + 1
  while lnum <= v:foldend && lnum <= v:foldstart + 5
    let next_line = getline(lnum)
    " Skip comments and empty lines
    if next_line !~? '^\$' && next_line !~? '^\s*$' && next_line !~? '^\*'
      let context = substitute(next_line, '^\s\+', '', '')
      let context = substitute(context, '\s\+', ' ', 'g')
      " Truncate if too long
      if len(context) > 50
        let context = context[0:49] . '...'
      endif
      break
    endif
    let lnum = lnum + 1
  endwhile
  
  " Build the fold text
  let fold_text = keyword
  if context != ""
    let fold_text = fold_text . ' | ' . context
  endif
  let fold_text = fold_text . ' '
  
  " Add fold line count
  let fold_size = printf("[%d lines] ", lines_count)
  
  " Calculate remaining space and add dots
  let window_width = winwidth(0)
  let used_width = len(fold_text) + len(fold_size)
  let dots_count = window_width - used_width - 1
  if dots_count > 0
    let dots = repeat('.', dots_count)
  else
    let dots = ''
  endif
  
  return fold_text . dots . fold_size
endfunction

" Key mappings for fold operations
" Use standard Vim folding commands:
"   za  - Toggle fold under cursor
"   zc  - Close fold under cursor
"   zo  - Open fold under cursor
"   zm  - Fold more (increase fold level)
"   zr  - Fold less (reduce fold level)
"   zM  - Close all folds
"   zR  - Open all folds
" Optional: Map Space to toggle fold (uncomment if desired)

" Helper function to find INCLUDE_PATH declarations before current line
" Returns a list of include paths found
function! s:FindIncludePaths()
  let paths = []
  let current_line = line('.')
  
  " Search backwards from current position for INCLUDE_PATH keywords
  let lnum = current_line - 1
  while lnum > 0
    let line = getline(lnum)
    
    " Found INCLUDE_PATH keyword
    if line =~? '^\*INCLUDE_PATH'
      " Read all path lines following INCLUDE_PATH until we hit a keyword, comment, or empty line
      let path_lnum = lnum + 1
      while path_lnum < current_line
        let path_line = getline(path_lnum)
        
        " Stop if we hit another keyword, end of block
        if path_line =~? '^\*'
          break
        endif
        
        " Stop if we hit a comment or empty line (end of path declarations)
        if path_line =~ '^\$' || path_line =~ '^\s*$'
          break
        endif
        
        " Extract and add path if line contains data
        if path_line =~ '\S'
          let path = matchstr(path_line, '^\s*\zs\S\+')
          " Remove quotes if present
          let path = substitute(path, '"', '', 'g')
          let path = substitute(path, "'", '', 'g')
          " Add to paths list (most recent first)
          call insert(paths, path, 0)
        endif
        
        let path_lnum = path_lnum + 1
      endwhile
    endif
    
    let lnum = lnum - 1
  endwhile
  
  return paths
endfunction

" Function to try multiple path combinations to find include file
" Returns the full path if found, empty string otherwise
function! s:ResolveIncludePath(filename)
  " Strategy 1: Try direct path as specified (current behavior)
  if filereadable(a:filename)
    return a:filename
  endif
  
  " Strategy 2: Try relative to current file's directory
  let dir = expand('%:p:h')
  let fullpath = dir . '/' . a:filename
  if filereadable(fullpath)
    return fullpath
  endif
  
  " Strategy 3: Try combining with INCLUDE_PATH declarations
  let include_paths = s:FindIncludePaths()
  for include_path in include_paths
    " Ensure path ends with separator if not already present
    let base_path = include_path
    if base_path !~ '[/\\]$'
      let base_path = base_path . '/'
    endif
    
    let combined_path = base_path . a:filename
    if filereadable(combined_path)
      return combined_path
    endif
    
    " Also try relative to current file, then to include path
    let combined_path = dir . '/' . base_path . a:filename
    if filereadable(combined_path)
      return combined_path
    endif
  endfor
  
  " File not found in any location
  return ""
endfunction

" Function to open INCLUDE files
function! LSDynaOpenInclude()
  let line = getline('.')
  
  " Check if we're on an INCLUDE line
  if line !~? '^\*INCLUDE'
    echo "Not on an INCLUDE line"
    return
  endif
  
  " Extract the filename from the line
  " INCLUDE files are typically specified after the keyword
  let filename = ""
  
  " Try to find filename in the current line or next line
  let next_line = getline(line('.') + 1)
  
  " Check if filename is on the same line (after keyword)
  if line =~ '^\*INCLUDE\s\+'
    let filename = matchstr(line, '^\*INCLUDE\s\+\zs\S\+')
  " Check if filename is on the next line
  elseif next_line !~ '^\$' && next_line !~ '^\*' && next_line =~ '\S'
    let filename = matchstr(next_line, '^\s*\zs\S\+')
  endif
  
  if filename == ""
    echo "Could not find filename to include"
    return
  endif
  
  " Remove any quotes
  let filename = substitute(filename, '"', '', 'g')
  let filename = substitute(filename, "'", '', 'g')
  
  " Resolve the file path using INCLUDE_PATH if needed
  let resolved_path = s:ResolveIncludePath(filename)
  
  if resolved_path == ""
    echo "File not found: " . filename
    return
  endif
  
  " Check if file is already open in current buffer to avoid reopening
  if expand('%:p') == fnamemodify(resolved_path, ':p')
    echo "File is already open in current buffer"
    return
  endif
  
  " Open in new tab with proper escaping
  try
    execute 'tabnew' fnameescape(resolved_path)
  catch
    echo "Error opening file: " . v:exception
  endtry
endfunction

" Function to open INCLUDE under cursor in split
function! LSDynaOpenIncludeSplit()
  let line = getline('.')
  
  if line !~? '^\*INCLUDE'
    echo "Not on an INCLUDE line"
    return
  endif
  
  let filename = ""
  let next_line = getline(line('.') + 1)
  
  if line =~ '^\*INCLUDE\s\+'
    let filename = matchstr(line, '^\*INCLUDE\s\+\zs\S\+')
  elseif next_line !~ '^\$' && next_line !~ '^\*' && next_line =~ '\S'
    let filename = matchstr(next_line, '^\s*\zs\S\+')
  endif
  
  if filename == ""
    echo "Could not find filename to include"
    return
  endif
  
  let filename = substitute(filename, '"', '', 'g')
  let filename = substitute(filename, "'", '', 'g')
  
  " Resolve the file path using INCLUDE_PATH if needed
  let resolved_path = s:ResolveIncludePath(filename)
  
  if resolved_path == ""
    echo "File not found: " . filename
    return
  endif
  
  " Check if file is already open in current buffer
  if expand('%:p') == fnamemodify(resolved_path, ':p')
    echo "File is already open in current buffer"
    return
  endif
  
  " Open in horizontal split with proper escaping
  try
    execute 'split' fnameescape(resolved_path)
  catch
    echo "Error opening file: " . v:exception
  endtry
endfunction

" Key mappings for opening INCLUDE files
" These mappings override Vim's default gf behavior to use custom INCLUDE navigation
" gf  - Open include file in new tab (when cursor is on *INCLUDE line)
" <C-w>f - Open include file in horizontal split
" <C-w>gf - Open include file in new tab (alternative)
" The <silent> flag suppresses output and <buffer> ensures mapping only applies to LS-DYNA files
nnoremap <silent> <buffer> gf :call LSDynaOpenInclude()<CR>
nnoremap <silent> <buffer> <C-w>f :call LSDynaOpenIncludeSplit()<CR>
nnoremap <silent> <buffer> <C-w>gf :call LSDynaOpenInclude()<CR>

" Leader key alternatives for opening INCLUDE files
" <leader>oi - Open include file in new tab
" <leader>os - Open include file in horizontal split
nnoremap <silent> <buffer> <leader>oi :call LSDynaOpenInclude()<CR>
nnoremap <silent> <buffer> <leader>os :call LSDynaOpenIncludeSplit()<CR>
" nnoremap <buffer> <Space> za

" Set comment string for commenting
setlocal commentstring=$\ %s
setlocal comments=:$

" Restore 'cpoptions'
let &cpo = s:save_cpo
unlet s:save_cpo