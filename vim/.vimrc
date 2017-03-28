" My .vimrc file
" Alessandro Lira


" Add line numbers:
set number

" Turn on code-syntax coloring:
syntax on

" Auto-format astericts for block comments:
set formatoptions+=r

" Set file-specifc plugins & indents
filetype plugin indent on
" show existing tabs w/ width = 4 spaces
set tabstop=4
" when indeinting with '>', use 4 spaces width
set shiftwidth=4
" on tab-press, insert 4 spaces
set expandtab
