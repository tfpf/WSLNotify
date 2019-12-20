colo torte
syn on

" on Windows: simulate a 'window maximise' keyboard command to start maximised
au GUIEnter * sim ~x

" save file to disk on each change
au TextChanged,TextChangedI <buffer> sil w
nn <silent> <C-S> :au TextChanged,TextChangedI <buffer> silent write<CR>

" highlight enclosing whitespace and enable searching for it
au Syntax * syn match leading_whitespace /^\s\+/ containedin=ALL
hi leading_whitespace ctermbg=235 guibg=#0f0f0f
nn lw /^\s\+<CR>
au Syntax * syn match trailing_whitespace /\s\+$/ containedin=ALL
hi trailing_whitespace ctermbg=235 guibg=#3f3f3f
nn tw /\s\+$<CR>

" set colour for warning column
hi ColorColumn ctermbg=235 guibg=#3f3f3f

" set colour for cursor line
hi CursorLine guibg=#1f1f1f

" remaining setup
se ai                  " automatic indent
se ar                  " automatically read file when changed from elsewhere
se bs=indent,eol,start " backspace clears text across lines
se cc=80,120           " define columns to highlight
se ci                  " copy previous line indent
se cul                 " highlight current line
se dy=lastline         " display line partially if entire line cannot be shown
se gfn=Consolas        " font
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
