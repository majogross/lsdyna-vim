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
" nnoremap <buffer> <Space> za

" Set comment string for commenting
setlocal commentstring=$\ %s
setlocal comments=:$

" Restore 'cpoptions'
let &cpo = s:save_cpo
unlet s:save_cpo