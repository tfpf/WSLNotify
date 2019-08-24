colorscheme torte
syntax on

" on Windows: simulate a 'window maximise' keyboard command to start maximised
au GUIEnter * sim ~x

" silently write file to disk on each change
au TextChanged,TextChangedI <buffer> silent write

" highlight trailing whitespace
au Syntax * syn match trailing_whitespace /\s\+$/ containedin=ALL

" indicate warning column
highlight ColorColumn ctermbg=235 guibg=#3f3f3f

" colour to use for trailing whitespace
highlight trailing_whitespace ctermbg=235 guibg=#3f3f3f

" options setup
set ai                  " automatic indent
set ar                  " automatically read file when changed from elsewhere
set bs=indent,eol,start " backspace clears text across lines
set cc=81,121           " define columns to highlight
set ci                  " copy previous line indent
set dy=lastline         " display line partially if entire line cannot be shown
set gfn=Consolas        " font
set hls                 " searching highlights search string
set lsp=0               " line spacing
set mh                  " hide mouse pointer while typing
set noet                " do not expand tabs to spaces
set sr                  " jump only at specified tabs when using >> or <<
set nosta               " use hard tabs, not spaces
set nowrap              " no word wrap
set nu                  " line numbers
set pi                  " preserve existing indentation when changing indent
set report=0            " threshold for reporting number of changed lines
set ru                  " ruler showing current cursor position
set sts=0               " do not insert spaces when pressing <Tab>
set sw=8                " number of spaces equal to an indent
set ts=8                " tabstop, length of a tab
set ul=1000             " number of undo operations allowed
