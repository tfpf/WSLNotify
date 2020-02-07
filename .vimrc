colo torte
syn on

au GUIEnter * sim ~x " Windows: start maximised
au TextChanged,TextChangedI <buffer> sil w " save file on change
au Syntax * syn match leading_whitespace /^\s\+/ containedin=ALL
au Syntax * syn match trailing_whitespace /\s\+$/ containedin=ALL

nn <silent> <C-S> :au TextChanged,TextChangedI <buffer> sil w<CR>:w<CR>
nn <C-Down> 15<Down>
nn <C-Up> 15<Up>
nn <silent> <F5> :mat Search_no /\<<C-R><C-W>\>/<CR>
nn <silent> g<F5> :mat Search_no /<C-R><C-W>/<CR>

hi ColorColumn guibg=#3f3f3f
hi CursorLine guibg=#1f1f1f
hi leading_whitespace guibg=#0f0f0f
hi trailing_whitespace guibg=#3f3f3f
hi Search gui=none guibg=#FF0000 guifg=#000000
hi Search_no gui=none guibg=#00BB00 guifg=#000000

se ai                  " automatic indent
se ar                  " automatically read file when changed from elsewhere
se bs=indent,eol,start " backspace clears text across lines
se cc=80,120           " colour these columns with `ColorColumn`
se ci                  " copy previous line indent
se cul                 " highlight current line
se dy=lastline         " display line partially if entire line cannot be shown
se enc=utf-8           " encoding
se fenc=utf-8          " file encoding
se gfn=Noto\ Mono:h9   " font
se hls                 " searching highlights search string
se lsp=0               " line spacing
se mh                  " hide mouse pointer while typing
se noet                " do not expand tabs to spaces
se sr                  " jump only at specified tabs when using >> or <<
se nosta               " use hard tabs, not spaces
se nowrap              " no word wrap
se nu                  " line numbers
se pi                  " preserve existing indentation when changing indent
se report=0            " threshold for reporting number of changed lines
se ru                  " ruler showing current cursor position
se sts=0               " do not insert spaces when pressing <Tab>
se sw=8                " number of spaces equal to an indent
se ts=8                " tabstop, length of a tab
se ul=1000             " number of undo operations allowed
