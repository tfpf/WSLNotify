" ~/.gvimrc

colo desert
syn on

" " maximise the GUI when gVim starts
" au GUIEnter * sim ~x

" " save the file whenever the buffer is changed
" au TextChanged,TextChangedI <buffer> sil w
" nn <silent> <C-S> :au TextChanged,TextChangedI <buffer> sil w<CR>:w<CR>

hi ColorColumn                                              guibg=#1f1f1f
hi CursorLine                                               guibg=#1f1f1f
hi Search                                          gui=none guibg=#FF0000 guifg=#000000
hi Cursor                                          gui=none
hi whitespace                                               guibg=#1f1f1f
hi a_small_price_to_pay_for_salvation              gui=none guibg=#00CF00 guifg=#000000
hi perfectly_balanced_as_all_things_should_be      gui=none guibg=#0000CF guifg=#FFFFFF
hi this_universe_is_finite_its_resources_finite    gui=none guibg=#CFCF00 guifg=#000000
hi dread_it_run_from_it_destiny_still_arrives      gui=none guibg=#00CFCF guifg=#000000
hi reality_is_often_dissapointing                  gui=none guibg=#CF00CF guifg=#FFFFFF
hi the_hardest_choices_require_the_strongest_wills gui=none guibg=#CFCFCF guifg=#000000

cal matchadd('whitespace', '\s\+$')

nn <silent> <M-1> :silent! cal matchdelete(alt_1)<CR> :let alt_1 = matchadd('a_small_price_to_pay_for_salvation',              '\<<C-R><C-W>\>')<CR>h
nn <silent> <M-2> :silent! cal matchdelete(alt_2)<CR> :let alt_2 = matchadd('perfectly_balanced_as_all_things_should_be',      '\<<C-R><C-W>\>')<CR>h
nn <silent> <M-3> :silent! cal matchdelete(alt_3)<CR> :let alt_3 = matchadd('this_universe_is_finite_its_resources_finite',    '\<<C-R><C-W>\>')<CR>h
nn <silent> <M-4> :silent! cal matchdelete(alt_4)<CR> :let alt_4 = matchadd('dread_it_run_from_it_destiny_still_arrives',      '\<<C-R><C-W>\>')<CR>h
nn <silent> <M-5> :silent! cal matchdelete(alt_5)<CR> :let alt_5 = matchadd('reality_is_often_dissapointing',                  '\<<C-R><C-W>\>')<CR>h
nn <silent> <M-6> :silent! cal matchdelete(alt_6)<CR> :let alt_6 = matchadd('the_hardest_choices_require_the_strongest_wills', '\<<C-R><C-W>\>')<CR>h

nn <C-Down> 15<Down>
nn <C-Up>   15<Up>

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
