" Vim completion file for LS-DYNA
" Provides dropdown menu with available abbreviations
" 
" Installation: Place in ~/.vim/after/ftplugin/lsdyna_complete.vim
"
" Usage: In insert mode, type 'lsd' then press Ctrl-X Ctrl-O
"        Or set up automatic completion (see below)

" Only load this for lsdyna filetype
if &filetype !=# 'lsdyna'
  finish
endif

" Enable omni-completion for this buffer
setlocal omnifunc=LSDynaComplete
setlocal completeopt=menu,menuone,longest

" Define the completion function
function! LSDynaComplete(findstart, base)
  if a:findstart
    " Locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    " Find completions matching the base
    let res = []
    
    " Define all available abbreviations with descriptions
    let completions = [
      \ {'word': 'lsdkeyword', 'menu': 'Complete file structure', 'info': 'KEYWORD, TITLE, END'},
      \ {'word': 'lsdtitle', 'menu': 'Title card', 'info': 'TITLE card with placeholder'},
      \ {'word': 'lsdcomment', 'menu': 'Comment block', 'info': 'Comment section with $ lines'},
      \ {'word': 'lsdend', 'menu': 'End keyword', 'info': 'END keyword'},
      \ {'word': 'lsdnode', 'menu': 'Node definition', 'info': 'NODE card with coordinates'},
      \ {'word': 'lsdelsolid', 'menu': 'Solid element', 'info': 'ELEMENT_SOLID with 8 nodes'},
      \ {'word': 'lsdelshell', 'menu': 'Shell element', 'info': 'ELEMENT_SHELL with 4 nodes'},
      \ {'word': 'lsdelbeam', 'menu': 'Beam element', 'info': 'ELEMENT_BEAM with orientation'},
      \ {'word': 'lsdpart', 'menu': 'Part definition', 'info': 'PART card with section and material'},
      \ {'word': 'lsdsecshell', 'menu': 'Shell section', 'info': 'SECTION_SHELL with thickness'},
      \ {'word': 'lsdsecsolid', 'menu': 'Solid section', 'info': 'SECTION_SOLID definition'},
      \ {'word': 'lsdsecbeam', 'menu': 'Beam section', 'info': 'SECTION_BEAM with properties'},
      \ {'word': 'lsdmatelastic', 'menu': 'Elastic material', 'info': 'MAT_ELASTIC (E, nu)'},
      \ {'word': 'lsdmatpwl', 'menu': 'Plasticity material', 'info': 'MAT_PIECEWISE_LINEAR_PLASTICITY'},
      \ {'word': 'lsdmatrigid', 'menu': 'Rigid material', 'info': 'MAT_RIGID with constraints'},
      \ {'word': 'lsdmatjc', 'menu': 'Johnson-Cook material', 'info': 'MAT_JOHNSON_COOK full definition'},
      \ {'word': 'lsdcontactss', 'menu': 'Surface to surface contact', 'info': 'CONTACT_AUTOMATIC_SURFACE_TO_SURFACE'},
      \ {'word': 'lsdcontactauto', 'menu': 'Single surface contact', 'info': 'CONTACT_AUTOMATIC_SINGLE_SURFACE'},
      \ {'word': 'lsdcontrolterm', 'menu': 'Termination control', 'info': 'CONTROL_TERMINATION (endtime)'},
      \ {'word': 'lsdcontroltime', 'menu': 'Timestep control', 'info': 'CONTROL_TIMESTEP settings'},
      \ {'word': 'lsdcontrolenergy', 'menu': 'Energy control', 'info': 'CONTROL_ENERGY options'},
      \ {'word': 'lsdcontrolhg', 'menu': 'Hourglass control', 'info': 'CONTROL_HOURGLASS settings'},
      \ {'word': 'lsdcontrolshell', 'menu': 'Shell control', 'info': 'CONTROL_SHELL parameters'},
      \ {'word': 'lsdcontrolsolid', 'menu': 'Solid control', 'info': 'CONTROL_SOLID parameters'},
      \ {'word': 'lsdcontrolacc', 'menu': 'Accuracy control', 'info': 'CONTROL_ACCURACY settings'},
      \ {'word': 'lsdd3plot', 'menu': 'D3PLOT output', 'info': 'DATABASE_BINARY_D3PLOT'},
      \ {'word': 'lsddbglstat', 'menu': 'Global statistics', 'info': 'DATABASE_GLSTAT output'},
      \ {'word': 'lsddbnodout', 'menu': 'Nodal output', 'info': 'DATABASE_NODOUT'},
      \ {'word': 'lsddbelout', 'menu': 'Element output', 'info': 'DATABASE_ELOUT'},
      \ {'word': 'lsddefcurve', 'menu': 'Load curve', 'info': 'DEFINE_CURVE with points'},
      \ {'word': 'lsddeftable', 'menu': 'Data table', 'info': 'DEFINE_TABLE'},
      \ {'word': 'lsdsetnodelist', 'menu': 'Node set', 'info': 'SET_NODE_LIST'},
      \ {'word': 'lsdsetpartlist', 'menu': 'Part set', 'info': 'SET_PART_LIST'},
      \ {'word': 'lsdsetsegment', 'menu': 'Segment set', 'info': 'SET_SEGMENT'},
      \ {'word': 'lsdboundaryspc', 'menu': 'SPC boundary', 'info': 'BOUNDARY_SPC_SET (fixed DOFs)'},
      \ {'word': 'lsdboundarypm', 'menu': 'Prescribed motion', 'info': 'BOUNDARY_PRESCRIBED_MOTION_SET'},
      \ {'word': 'lsdloadnode', 'menu': 'Nodal load', 'info': 'LOAD_NODE_SET'},
      \ {'word': 'lsdloadseg', 'menu': 'Segment load', 'info': 'LOAD_SEGMENT_SET (pressure)'},
      \ {'word': 'lsdinitvel', 'menu': 'Initial velocity', 'info': 'INITIAL_VELOCITY (node)'},
      \ {'word': 'lsdinitvelgen', 'menu': 'Initial velocity generation', 'info': 'INITIAL_VELOCITY_GENERATION (set)'},
      \ {'word': 'lsdinclude', 'menu': 'Include file', 'info': 'INCLUDE external file'},
      \ {'word': 'lsdparameter', 'menu': 'Parameter definition', 'info': 'PARAMETER (variable)'},
      \ {'word': 'lsdparameterexpr', 'menu': 'Parameter expression', 'info': 'PARAMETER_EXPRESSION (formula)'},
      \ ]
    
    " Filter completions based on what user typed
    for item in completions
      if item.word =~ '^' . a:base
        call add(res, item)
      endif
    endfor
    
    return res
  endif
endfunction

" Set up automatic completion popup when typing 'lsd'
augroup lsdyna_complete
  autocmd!
  " Trigger completion automatically when typing 'lsd'
  autocmd CompleteDone <buffer> if pumvisible() == 0 | pclose | endif
augroup END

" Map Ctrl-Space to trigger completion
inoremap <buffer> <C-Space> <C-x><C-o>
inoremap <buffer> <C-@> <C-x><C-o>

" Optional: Auto-trigger completion after typing 'lsd'
" Uncomment the following lines if you want automatic popup
" augroup lsdyna_auto_complete
"   autocmd!
"   autocmd TextChangedI <buffer> call s:AutoComplete()
" augroup END
"
" function! s:AutoComplete()
"   let line = getline('.')
"   let col = col('.') - 1
"   let before = line[:col-1]
"   if before =~ 'lsd\w*$' && pumvisible() == 0
"     call feedkeys("\<C-x>\<C-o>", 'n')
"   endif
" endfunction

echo "LS-DYNA completion loaded. Press Ctrl-X Ctrl-O or Ctrl-Space after 'lsd' to see menu"