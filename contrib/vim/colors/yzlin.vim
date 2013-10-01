" Vim color file
" Maintainer:	Yi-Jheng, Lin <yzlin1985@gmail.com>
" Last Change:	26/05/08 22:02:51

hi clear

if exists("syntax_on")
    syntax reset
endif

let colors_name = "yzlin"

" Normal should come first
hi Normal	guifg=Black	guibg=White
hi Cursor	guifg=bg	guibg=fg
hi lCursor	guifg=NONE	guibg=Cyan

" Note: we never set 'term' because the defaults for B&W terminals are OK
hi DiffAdd			ctermbg=LightBlue
hi DiffChange			ctermbg=LightMagenta
hi DiffDelete			ctermfg=Blue		ctermbg=LightCyan
hi DiffText	cterm=bold				ctermbg=Red
hi Directory			ctermfg=DarkBlue
hi ErrorMsg			ctermfg=White		ctermbg=DarkRed
hi FoldColumn			ctermfg=DarkBlue	ctermbg=Grey
hi Folded			ctermfg=DarkBlue	ctermbg=Grey
hi IncSearch	cterm=reverse
hi LineNr	cterm=NONE	ctermfg=DarkGrey
hi ModeMsg	cterm=bold				ctermbg=DarkRed
hi MoreMsg			ctermfg=DarkGreen
hi NonText			ctermfg=Blue
hi Pmenu						ctermbg=Blue
hi PmenuSel			ctermfg=White		ctermbg=DarkBlue
hi Question			ctermfg=DarkGreen
hi Search			ctermfg=Black		ctermbg=Red
hi SpecialKey			ctermfg=DarkBlue
hi StatusLine	cterm=bold	ctermfg=Yellow		ctermbg=Blue
hi StatusLineNC	cterm=bold	ctermfg=black		ctermbg=Blue
hi Title			ctermfg=DarkMagenta
hi VertSplit	cterm=reverse
hi Visual	cterm=reverse	ctermfg=Cyan		ctermbg=NONE
hi VisualNOS	cterm=underline,bold
hi WarningMsg			ctermfg=DarkRed
hi WildMenu			ctermfg=Black		ctermbg=Yellow

" syntax highlighting
hi Comment	cterm=NONE	ctermfg=DarkGrey

"hi Constant	cterm=NONE	ctermfg=DarkGreen
hi String	cterm=NONE	ctermfg=Magenta
hi Character	cterm=NONE	ctermfg=Magenta
hi Number	cterm=NONE	ctermfg=DarkGreen
hi Boolean	cterm=NONE	ctermfg=DarkGreen
hi Float	cterm=NONE	ctermfg=Green

"hi Identifier	cterm=NONE	ctermfg=DarkCyan
hi Function	cterm=NONE	ctermfg=Cyan

"hi Statement	cterm=bold	ctermfg=Blue
hi Conditional	cterm=NONE	ctermfg=DarkYellow
hi Repeat	cterm=NONE	ctermfg=DarkYellow
hi Label	cterm=NONE	ctermfg=DarkYellow
hi Operator	cterm=NONE	ctermfg=Red
hi Keyword	cterm=NONE	ctermfg=Red
hi Exception	cterm=NONE	ctermfg=DarkYellow

hi PreProc	cterm=NONE	ctermfg=DarkMagenta
"hi Include	cterm=NONE	ctermfg=DarkMagenta
"hi Define	cterm=NONE	ctermfg=DarkMagenta
"hi Macro	cterm=NONE	ctermfg=DarkMagenta
"hi PreCondit	cterm=NONE	ctermfg=DarkMagenta

hi Type		cterm=NONE	ctermfg=Blue
hi StorageClass	cterm=NONE	ctermfg=Blue
hi Structure	cterm=NONE	ctermfg=DarkCyan
hi Typedef	cterm=NONE	ctermfg=Cyan

hi Special		cterm=NONE	ctermfg=Red
"hi SpecialChar		cterm=NONE	ctermfg=Red
"hi Tag			cterm=NONE	ctermfg=Red
"hi Delimiter		cterm=NONE	ctermfg=Red
"hi SpecialComment	cterm=NONE	ctermfg=Red
"hi Debug		cterm=NONE	ctermfg=Red

"hi Underlined	cterm=NONE	ctermfg=Red

"hi Ignore	cterm=NONE	ctermfg=Red

"hi Error	cterm=NONE	ctermfg=Red

hi Todo		cterm=NONE	ctermfg=Yellow
