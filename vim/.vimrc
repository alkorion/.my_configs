" My .vimrc file
" Alessandro Lira


" Add line numbers:
set number

" Ignore case when searching
set ignorecase

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

" turn on column higlighting
set colorcolumn=
" create range of columns to highlight
let &colorcolumn="80,120"
" set highlight color (light-blue) of columns
highlight ColorColumn ctermbg=6
