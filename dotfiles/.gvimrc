colo desert
syn on

" " Save the file whenever the buffer is changed.
" au TextChanged,TextChangedI <buffer> sil w

" Specify syntax for files GVIM does not know about.
au BufRead,BufNewFile *.sage setfiletype python

hi ColorColumn                                     gui=NONE      guibg=#333333 guifg=NONE    term=reverse   cterm=NONE      ctermbg=236  ctermfg=NONE
hi Comment                                         gui=italic    guibg=NONE    guifg=#667777 term=bold      cterm=italic    ctermbg=NONE ctermfg=242
hi Cursor                                          gui=NONE      guibg=#F0E68C guifg=#4D4D4D
hi CursorLine                                      gui=NONE      guibg=#333333 guifg=NONE    term=underline cterm=NONE      ctermbg=236  ctermfg=NONE
hi CursorLineNr                                    gui=NONE      guibg=NONE    guifg=#EEEE00 term=underline cterm=NONE      ctermbg=NONE ctermfg=226
hi DiffAdd                                         gui=NONE      guibg=#00008B guifg=NONE    term=bold      cterm=NONE      ctermbg=4    ctermfg=NONE
hi DiffChange                                      gui=NONE      guibg=#8B008B guifg=NONE    term=bold      cterm=NONE      ctermbg=5    ctermfg=NONE
hi DiffDelete                                      gui=bold      guibg=#008B8B guifg=#0000FF term=bold      cterm=bold      ctermbg=6    ctermfg=4
hi DiffText                                        gui=bold      guibg=#B80000 guifg=NONE    term=reverse   cterm=bold      ctermbg=1    ctermfg=NONE
hi IncSearch                                       gui=NONE      guibg=#808080 guifg=#D7D75F                cterm=NONE      ctermbg=244  ctermfg=185
hi LineNr                                          gui=NONE      guibg=NONE    guifg=#808000 term=underline cterm=NONE      ctermbg=NONE ctermfg=3
hi MatchParen                                      gui=NONE      guibg=#008888 guifg=NONE    term=reverse                   ctermbg=30   ctermfg=NONE
hi NonText                                                       guibg=#121212                                              ctermbg=233
hi Normal                                          gui=NONE      guibg=#1F1F1F guifg=#FFFFFF term=NONE      cterm=NONE      ctermbg=234  ctermfg=231
hi Search                                          gui=NONE      guibg=#FF0000 guifg=#000000 term=reverse                   ctermbg=196  ctermfg=16
hi SpecialComment                                  gui=italic    guibg=NONE    guifg=#FFDE9B term=italic    cterm=italic    ctermbg=NONE ctermfg=222
hi SpecialKey                                      gui=NONE      guibg=NONE    guifg=#626262 term=NONE      cterm=NONE      ctermbg=NONE ctermfg=241
hi StatusLine                                      gui=NONE      guibg=#AFAF87 guifg=#303030                cterm=NONE      ctermbg=144  ctermfg=236
hi StatusLineNC                                    gui=NONE      guibg=#AFAF87 guifg=#808080                cterm=NONE      ctermbg=144  ctermfg=244
hi VertSplit                                       gui=NONE      guibg=#AFAF87 guifg=#808080                cterm=NONE      ctermbg=144  ctermfg=244
hi Visual                                                        guibg=#079486 guifg=#FFFFFF term=reverse   cterm=NONE      ctermbg=231  ctermfg=30
hi VisualNOS                                       gui=underline guibg=NONE    guifg=NONE    term=underline cterm=underline ctermbg=NONE ctermfg=NONE

hi a_small_price_to_pay_for_salvation              gui=NONE      guibg=#00CF00 guifg=#000000
hi perfectly_balanced_as_all_things_should_be      gui=NONE      guibg=#0000FF guifg=#FFFFFF
hi this_universe_is_finite_its_resources_finite    gui=NONE      guibg=#CFCF00 guifg=#000000
hi dread_it_run_from_it_destiny_still_arrives      gui=NONE      guibg=#00CFCF guifg=#000000
hi reality_is_often_dissapointing                  gui=NONE      guibg=#CF00CF guifg=#FFFFFF
hi the_hardest_choices_require_the_strongest_wills gui=NONE      guibg=#CFCFCF guifg=#000000

nn <silent> <M-1> :silent! cal matchdelete(alt_1)<CR>:let alt_1 = matchadd('a_small_price_to_pay_for_salvation',              '\<<C-R><C-W>\>')<CR>
nn <silent> <M-2> :silent! cal matchdelete(alt_2)<CR>:let alt_2 = matchadd('perfectly_balanced_as_all_things_should_be',      '\<<C-R><C-W>\>')<CR>
nn <silent> <M-3> :silent! cal matchdelete(alt_3)<CR>:let alt_3 = matchadd('this_universe_is_finite_its_resources_finite',    '\<<C-R><C-W>\>')<CR>
nn <silent> <M-4> :silent! cal matchdelete(alt_4)<CR>:let alt_4 = matchadd('dread_it_run_from_it_destiny_still_arrives',      '\<<C-R><C-W>\>')<CR>
nn <silent> <M-5> :silent! cal matchdelete(alt_5)<CR>:let alt_5 = matchadd('reality_is_often_dissapointing',                  '\<<C-R><C-W>\>')<CR>
nn <silent> <M-6> :silent! cal matchdelete(alt_6)<CR>:let alt_6 = matchadd('the_hardest_choices_require_the_strongest_wills', '\<<C-R><C-W>\>')<CR>

nn <C-Down> 15<Down>
nn <C-Up>   15<Up>

se ai                        " New line is automatically indented.
se ar                        " Automatically read file when changed from elsewhere.
se bs=indent,eol,start       " Backspace freely.
se cc=80,120                 " Columns to be coloured with `ColorColumn`.
se ch=1                      " Number of lines to use to display commands.
se ci                        " Indentation for a new line is identical to the previous line.
se cink=                     " Don't change the indentation of the being typed.
se cul                       " Highlight current line.
se dy=lastline               " If the last line cannot be shown in its entirety, show a part of it.
se enc=utf-8                 " Internal representation.
se et                        " Expand tabs to spaces.
se fenc=utf-8                " Representation of current buffer.
se fixeol                    " Add an end-of-line character at the end of a file.
se fo=                       " Do not insert the comment marker when starting a new line.
se gcr=n:blinkwait0          " Disable cursor blink in normal mode.
se hls                       " Searching highlights all matches.
se inde=                     " Don't calculate the proper indentation.
se indk=                     " Don't change the indentation of the being typed.
se is                        " Incremental search.
se lcs=nbsp:␣,tab:▶·,trail:· " How to display certain characters. They will be coloured with `SpecialKey`.
se list                      " Display certain characters more prominently. See `lcs`.
se lsp=0                     " Line spacing.
se mh                        " Hide mouse pointer while typing.
se nosi                      " Don't try to be oversmart while indenting.
se nosm                      " Do not jump to the matching bracket one is inserted.
se noswapfile                " Do not create swap files.
se nowrap                    " Do not wrap lines.
se nu                        " Line numbers.
se pi                        " Preserve as much of the existing indentation as possible when changing said indentation.
se report=0                  " Threshold for reporting number of changed lines.
se ru                        " Ruler showing current cursor position.
se sc                        " Show partial command information.
se so=3                      " Number of lines visible above and below cursor.
se sr                        " When using '>>' or '<<', only jump to columns which are multiples of `sw`.
se sta                       " Tab inserts an `sw`-size character at the start of a line, and `ts`-size elsewhere.
se sts=0                     " Do not insert spaces when pressing Tab.
se sw=4                      " Shift width. See `sta`.
se tgc                       " Use 24-bit colours, so that VIM and GVIM look the same.
se timeout                   " Time out on mappings and key codes.
se timeoutlen=0              " Time to wait until a mapping sequence is completely entered.
se ttimeoutlen=-1            " Wait for `timeoutlen` until a key code sequence is completely entered.
se ts=4                      " Tab stop. See `sta`.
se tw=0                      " Do not break lines automatically.
se ul=1000                   " Number of undo operations allowed.

if has('win32') || has('win64')
    au GUIEnter * sim ~x
    nn <silent> <F2> :so ~/_gvimrc<CR>
    se gfn=Cascadia\ Code:h13           " The patched version does not work.
    se rop=type:directx,gamma:1.0       " Enable ligatures, but don't brighten the text.
    se scf                              " Scroll focus follows mouse pointer.
elseif has('unix')
    au GUIEnter * call system('wmctrl -b add,maximized_horz,maximized_vert -i -r ' . v:windowid)
    nn <silent> <F2> :so ~/.gvimrc<CR>
    se gfn=CaskaydiaCove\ Nerd\ Font\ 13
    se gli=!#$%&()*+-./:;<=>?@[\\]^_w{\|}~
endif

" No syntax highlighting in comment strings.
if exists("c_comment_strings")
    unlet c_comment_strings
endif
if exists("java_comment_strings")
    unlet java_comment_strings
endif

" Better syntax highlighting for Java.
let java_highlight_all = 1
let java_highlight_functions = 1
hi link javaScopeDecl Statement
hi link javaType Type
