" Vim filetype detection file for LS-DYNA input files
" Place this file in ~/.vim/ftdetect/ or use the vimrc instructions below

" Detect LS-DYNA input files by extension
au BufRead,BufNewFile *.k setfiletype lsdyna
au BufRead,BufNewFile *.key setfiletype lsdyna
au BufRead,BufNewFile *.dyn setfiletype lsdyna
au BufRead,BufNewFile *.inc setfiletype lsdyna
au BufRead,BufNewFile *.k.* setfiletype lsdyna
au BufRead,BufNewFile *.key.* setfiletype lsdyna

" Detect by content - files starting with LS-DYNA keyword marker
au BufRead,BufNewFile * if getline(1) =~ '^\*KEYWORD' | setfiletype lsdyna | endif