syntax on
colorscheme torte

set ai
set backspace=indent,eol,start
set ci
set guifont=Consolas
set noexpandtab
set nowrap
set nu

let &colorcolumn="81,121"
highlight ColorColumn ctermbg=235 guibg=#2c2d27

au GUIEnter * sim ~x
au TextChanged,TextChangedI <buffer> silent write

