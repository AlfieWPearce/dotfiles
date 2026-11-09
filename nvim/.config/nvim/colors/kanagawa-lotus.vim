" Name:       kangawa-dragon.vim
" Version:    0.1.0
" Maintainer: AlfiePearce
" License:    MIT
"
" A minimal colorscheme inspired by "Kangawa Lotus"
"

hi clear
if exists('syntax on')
    syntax reset
endif
let g:colors_name='kangawa-lotus'

" ====================
" Palette
" ====================
let s:none         = {"gui":"NONE","cterm":"NONE"}

let s:black        = {"gui": "#0B0C10", "cterm": "233"}
let s:dark_gray    = {"gui": "#1F2833", "cterm": "236"}
let s:gray        = {"gui":"#A0A8B0","cterm":"248"}
let s:white       = {"gui":"#F7F7F7","cterm":"15"}

let s:dark_purple = {"gui":"#2B1B2F","cterm":"234"}
let s:purple      = {"gui":"#C792EA","cterm":"135"}
let s:pink        = {"gui":"#F29ACB","cterm":"213"}
let s:light_pink  = {"gui":"#FFD6E7","cterm":"225"}
let s:blue        = {"gui":"#7FB4CA","cterm":"109"}
let s:red          = {"gui": "#FF2C2C", "cterm": "9"}
let s:orange       = {"gui": "#FF8C42", "cterm": "208"}
let s:yellow       = {"gui": "#FFD93D", "cterm": "11"}
let s:green        = {"gui": "#21E6C1", "cterm": "6"}

" Background setup
let s:background = &background
if &background == "dark"
  let s:bg        = s:none
  let s:fg        = s:white
  let s:cursor    = s:green
else
  let s:bg        = s:none
  let s:fg        = s:black
  let s:cursor    = s:blue
endif

" ====================
" Helper function
" ====================
function! s:h(group, style)
  execute "highlight" a:group
        \ "guifg="   (has_key(a:style,"fg")  ? a:style.fg.gui  : "NONE")
        \ "guibg="   (has_key(a:style,"bg")  ? a:style.bg.gui  : "NONE")
        \ "guisp="   (has_key(a:style,"sp")  ? a:style.sp.gui  : "NONE")
        \ "gui="     (has_key(a:style,"gui") ? a:style.gui    : "NONE")
        \ "ctermfg=" (has_key(a:style,"fg")  ? a:style.fg.cterm : "NONE")
        \ "ctermbg=" (has_key(a:style,"bg")  ? a:style.bg.cterm : "NONE")
        \ "cterm="   (has_key(a:style,"cterm") ? a:style.cterm : "NONE")
endfunction

" ====================
" Core highlights
" ====================
call s:h("Normal", {"fg": s:fg, "bg": s:bg})
call s:h("Cursor", {"fg": s:bg, "bg": s:cursor})
call s:h("Comment", {"fg": s:gray, "gui": "italic"})
call s:h("Constant", {"fg": s:pink})
call s:h("String", {"fg": s:light_pink})
call s:h("Identifier", {"fg": s:blue})
call s:h("Function", {"fg": s:purple})
call s:h("Statement", {"fg": s:pink})
call s:h("Keyword", {"fg": s:purple, "gui": "bold"})
call s:h("Type", {"fg": s:pink})
call s:h("Special", {"fg": s:purple, "gui": "italic"})
call s:h("Underlined", {"fg": s:blue, "gui": "underline"})
call s:h("Error", {"fg": s:bg, "bg": s:red, "gui": "bold"})
call s:h("Todo", {"fg": s:light_pink, "gui": "underline"})

" ====================
" UI highlights
" ====================
call s:h("LineNr", {"fg": s:gray})
call s:h("CursorLineNr", {"fg": s:light_pink, "bg": s:bg})
call s:h("StatusLine", {"fg": s:fg, "bg": s:bg})
call s:h("StatusLineNC", {"fg": s:gray, "bg": s:bg})
call s:h("VertSplit", {"fg": s:gray})
call s:h("Pmenu", {"fg": s:fg, "bg": s:bg})
call s:h("PmenuSel", {"fg": s:bg, "bg": s:purple})
call s:h("Visual", {"bg": s:pink})

" ====================
" Diff highlights
" ====================
call s:h("DiffAdd", {"fg": s:green})
call s:h("DiffDelete", {"fg": s:red})
call s:h("DiffChange", {"fg": s:orange})
call s:h("DiffText", {"fg": s:yellow})

" ====================
" Link common groups
" ====================
hi! link Boolean Constant
hi! link Number Constant
hi! link Character Constant
hi! link Conditional Statement
hi! link Repeat Statement
hi! link Label Statement
hi! link Exception Statement

" ===
" Common
" ===
call s:h("htmlH1",        {"bg": s:bg, "fg": s:fg})
call s:h("htmlH2",        {"bg": s:bg, "fg": s:fg})
call s:h("htmlH3",        {"bg": s:bg, "fg": s:fg})
call s:h("htmlH4",        {"bg": s:bg, "fg": s:fg})
call s:h("htmlH5",        {"bg": s:bg, "fg": s:fg})
call s:h("htmlH6",        {"bg": s:bg, "fg": s:fg})

" Synatastic
call s:h("SyntasticWarningSign",    {"fg": s:yellow})
call s:h("SyntasticWarning",        {"bg": s:yellow, "fg": s:black, "gui": "bold", "cterm": "bold"})
call s:h("SyntasticErrorSign",      {"fg": s:red})
call s:h("SyntasticError",          {"bg": s:red, "fg": s:white, "gui": "bold", "cterm": "bold"})

" Neomake
hi link NeomakeWarningSign	SyntasticWarningSign
hi link NeomakeErrorSign	SyntasticErrorSign

" ALE
hi link ALEWarningSign	SyntasticWarningSign
hi link ALEErrorSign	SyntasticErrorSign

" Signify, git-gutter
hi link SignifySignAdd              LineNr
hi link SignifySignDelete           LineNr
hi link SignifySignChange           LineNr
hi link GitGutterAdd                LineNr
hi link GitGutterDelete             LineNr
hi link GitGutterChange             LineNr
hi link GitGutterChangeDelete       LineNr

" Treesitter Overrides
hi! link @keyword Keyword
hi! link @string String
hi! link @function Function
hi! link @type Type
hi! link @comment Comment
hi! link @operator Operator
hi! link @punctuation Delimiter
hi! link @variable Normal

" Mini overrides
hi! MiniFilesNormal guibg=NONE ctermbg=NONE
hi! MiniFilesBorder guibg=NONE ctermbg=NONE
hi! MiniFilesFile   guibg=NONE ctermbg=NONE
hi! MiniPickNormal  guibg=NONE ctermbg=NONE
hi! MiniPickBorder  guibg=NONE ctermbg=NONE

