colo desert
syn on

au GUIEnter * sim ~x " Windows: start maximised
" au TextChanged,TextChangedI <buffer> sil w " save file on change

hi ColorColumn                                              guibg=#1f1f1f
hi CursorLine                                               guibg=#1f1f1f
hi Search                                          gui=none guibg=#FF0000 guifg=#000000
hi Cursor                                          gui=none
hi whitespace                                               guibg=#1f1f1f
hi perfectly_balanced_as_all_things_should_be      gui=none guibg=#00BB00 guifg=#000000
hi the_hardest_choices_require_the_strongest_wills gui=none guibg=#00BBBB guifg=#000000
hi little_one_its_a_simple_calculus                gui=none guibg=#BBBB00 guifg=#000000

cal matchadd('whitespace', '\s\+$')

nn <C-Down> 15<Down>
nn <C-Up>   15<Up>
" nn <silent> <C-S> :au TextChanged,TextChangedI <buffer> sil w<CR>:w<CR>
nn <silent> <F5> :silent! cal matchdelete(key_F5)<CR> :let key_F5 = matchadd('perfectly_balanced_as_all_things_should_be',      '\<<C-R><C-W>\>')<CR>
nn <silent> <F6> :silent! cal matchdelete(key_F6)<CR> :let key_F6 = matchadd('the_hardest_choices_require_the_strongest_wills', '\<<C-R><C-W>\>')<CR>
nn <silent> <F7> :silent! cal matchdelete(key_F7)<CR> :let key_F7 = matchadd('little_one_its_a_simple_calculus',                '\<<C-R><C-W>\>')<CR>

se ai                      " automatic indent
se ar                      " automatically read file when changed from elsewhere
se bs=indent,eol,start     " backspace clears text across lines
se cc=80,120               " colour these columns with `ColorColumn'
se ci                      " copy previous line indent
se cul                     " highlight current line
se dy=lastline             " display line partially if entire line cannot be shown
se enc=utf-8               " encoding: how it is written
se fenc=utf-8              " encoding: how it is read
se gcr=n:blinkwait0        " disable cursor blink
se gfn=Cascadia\ Code:h12  " font
se hls                     " searching highlights search string
se lsp=0                   " line spacing
se mh                      " hide mouse pointer while typing
se noet                    " do not expand tabs to spaces
se noswapfile              " do not create swap files
se sr                      " jump only at specified tabs when using >> or <<
se nosta                   " use hard tabs, not spaces
se nowrap                  " no word wrap
se nu                      " line numbers
se pi                      " preserve existing indentation when changing indent
se report=0                " threshold for reporting number of changed lines
se ru                      " ruler showing current cursor position
se sts=0                   " do not insert spaces when pressing <Tab>
se sw=8                    " number of spaces equal to an indent
se ts=8                    " tabstop, length of a tab
se ul=1000                 " number of undo operations allowed
