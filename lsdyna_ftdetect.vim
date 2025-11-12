" Vim filetype detection file for LS-DYNA input files
" Place this file in ~/.vim/ftdetect/ or use the vimrc instructions below

" Detect LS-DYNA input files by extension
au BufRead,BufNewFile *.k setf lsdyna
au BufRead,BufNewFile *.key setf lsdyna
au BufRead,BufNewFile *.dyn setf lsdyna
au BufRead,BufNewFile *.inc setf lsdyna
au BufRead,BufNewFile *.k.* setf lsdyna
au BufRead,BufNewFile *.key.* setf lsdyna

" Detect by content - files starting with LS-DYNA keyword marker
au BufRead,BufNewFile * if getline(1) =~ '^\*KEYWORD' | setf lsdyna | endif