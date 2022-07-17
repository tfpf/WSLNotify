" ~/.gvimrc

colo desert
syn on

" " Save the file whenever the buffer is changed.
" au TextChanged,TextChangedI <buffer> sil w

" Specify syntax for files GVIM does not know about.
au BufRead,BufNewFile *.sage setfiletype python

" To re-load this file. Useful if some stupid plugin overwrites my preferences.
nn <silent> <C-S> :so ~/.gvimrc<CR>

hi ColorColumn                                              guibg=#1F1F1F
hi CursorLine                                               guibg=#1F1F1F
hi Search                                          gui=none guibg=#FF0000 guifg=#000000
hi Cursor                                          gui=none
hi NonText                                                  guibg=#444444
hi whitespace                                               guibg=#1F1F1F
hi a_small_price_to_pay_for_salvation              gui=none guibg=#00CF00 guifg=#000000
hi perfectly_balanced_as_all_things_should_be      gui=none guibg=#0000FF guifg=#FFFFFF
hi this_universe_is_finite_its_resources_finite    gui=none guibg=#CFCF00 guifg=#000000
hi dread_it_run_from_it_destiny_still_arrives      gui=none guibg=#00CFCF guifg=#000000
hi reality_is_often_dissapointing                  gui=none guibg=#CF00CF guifg=#FFFFFF
hi the_hardest_choices_require_the_strongest_wills gui=none guibg=#CFCFCF guifg=#000000

cal matchadd('whitespace', '\s\+$')

nn <silent> <M-1> :silent! cal matchdelete(alt_1)<CR>:let alt_1 = matchadd('a_small_price_to_pay_for_salvation',              '\<<C-R><C-W>\>')<CR>
nn <silent> <M-2> :silent! cal matchdelete(alt_2)<CR>:let alt_2 = matchadd('perfectly_balanced_as_all_things_should_be',      '\<<C-R><C-W>\>')<CR>
nn <silent> <M-3> :silent! cal matchdelete(alt_3)<CR>:let alt_3 = matchadd('this_universe_is_finite_its_resources_finite',    '\<<C-R><C-W>\>')<CR>
nn <silent> <M-4> :silent! cal matchdelete(alt_4)<CR>:let alt_4 = matchadd('dread_it_run_from_it_destiny_still_arrives',      '\<<C-R><C-W>\>')<CR>
nn <silent> <M-5> :silent! cal matchdelete(alt_5)<CR>:let alt_5 = matchadd('reality_is_often_dissapointing',                  '\<<C-R><C-W>\>')<CR>
nn <silent> <M-6> :silent! cal matchdelete(alt_6)<CR>:let alt_6 = matchadd('the_hardest_choices_require_the_strongest_wills', '\<<C-R><C-W>\>')<CR>

nn <C-Down> 15<Down>
nn <C-Up>   15<Up>

se ai                      " New line is automatically indented.
se ar                      " Automatically read file when changed from elsewhere.
se bs=indent,eol,start     " Backspace freely.
se cc=80,120               " Columns to be coloured with `ColorColumn'.
se ci                      " Indentation for a new line is identical to the previous line.
se cink=                   " Don't change the indentation of the being typed.
se cul                     " Highlight current line.
se dy=lastline             " If the last line cannot be shown in its entirety, show a part of it.
se enc=utf-8               " Internal representation.
se et                      " Expand tabs to spaces.
se fenc=utf-8              " Representation of current buffer.
se fixeol                  " Add an end-of-line character at the end of a file.
se fo=                     " Do not insert the comment marker when starting a new line.
se gcr=n:blinkwait0        " Disable cursor blink in normal mode.
se hls                     " Searching highlights all matches.
se inde=                   " Don't calculate the proper indentation.
se indk=                   " Don't change the indentation of the being typed.
se is                      " Incremental search.
se lsp=0                   " Line spacing.
se mh                      " Hide mouse pointer while typing.
se nosi                    " Don't try to be oversmart while indenting.
se noswapfile              " Do not create swap files.
se nowrap                  " Do not wrap lines.
se nu                      " Line numbers.
se pi                      " Preserve as much of the existing indentation as possible when changing said indentation.
se report=0                " Threshold for reporting number of changed lines.
se ru                      " Ruler showing current cursor position.
se sc                      " Show partial command information.
se so=3                    " Number of lines visible above and below cursor.
se sr                      " When using '>>' or '<<', only jump to columns which are multiples of `sw'.
se sta                     " Tab inserts an `sw'-size character at the start of a line, and `ts'-size elsewhere.
se sts=0                   " Do not insert spaces when pressing Tab.
se sw=4                    " Shift width. See `sta'.
se ts=4                    " Tab stop. See `sta'.
se tw=0                    " Do not break lines automatically.
se ul=1000                 " Number of undo operations allowed.

if has('win32') || has('win64')
    au GUIEnter * sim ~x
    se gfn=Cascadia\ Code:h13 " GUI font.
    se rop=                   " `type:directx' enables ligatures, but makes text bold. I don't like that.
    se scf                    " Scroll focus follows mouse pointer.
elseif has('unix')
    au GUIEnter * call system('wmctrl -b add,maximized_horz,maximized_vert -i -r ' . v:windowid)
    se gfn=Cascadia\ Code\ 13
endif

" No syntax highlighting in comment strings.
if exists("c_comment_strings")
    unlet c_comment_strings
endif
