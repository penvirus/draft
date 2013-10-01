" Vim color file
" Name:       yzlin256.vim
" Maintainer: Y.Z. Lin <yzlin1985@gmail.com>

hi clear
set background=dark
if exists("syntax_on")
   syntax reset
endif

let g:colors_name = "yzlin256"

if &t_Co == 256
    hi DiffAdd           cterm=NONE  ctermfg=231 ctermbg=22
    hi DiffChange        cterm=NONE  ctermfg=231 ctermbg=17
    hi DiffDelete        cterm=NONE  ctermfg=231 ctermbg=52
    hi DiffText          cterm=NONE  ctermfg=231 ctermbg=55
    hi Directory         cterm=NONE  ctermfg=46  ctermbg=NONE
    hi ErrorMsg          cterm=BOLD  ctermfg=16  ctermbg=124
    hi FoldColumn        cterm=NONE  ctermfg=163 ctermbg=232
    hi Folded            cterm=NONE  ctermfg=231 ctermbg=57
    hi IncSearch         cterm=BOLD  ctermfg=232 ctermbg=119
    hi LineNr            cterm=NONE  ctermfg=240 ctermbg=232
    hi MBEChanged                    ctermfg=253 ctermbg=235
    hi MBENormal                     ctermfg=247 ctermbg=235
    hi MBEVisibleChanged             ctermfg=253 ctermbg=238
    hi MBEVisibleNormal              ctermfg=247 ctermbg=238
    hi ModeMsg           cterm=BOLD  ctermfg=61  ctermbg=NONE
    hi MoreMsg           cterm=BOLD  ctermfg=61  ctermbg=NONE
    hi NonText           cterm=BOLD  ctermfg=63  ctermbg=NONE
    hi Normal            cterm=NONE  ctermfg=231 ctermbg=0
    hi Question          cterm=BOLD  ctermfg=130 ctermbg=NONE
    hi Search            cterm=NONE  ctermfg=232 ctermbg=119
    hi Special           cterm=NONE  ctermfg=135 ctermbg=NONE
    hi SpecialChar       cterm=NONE  ctermfg=135 ctermbg=235
    hi SpecialKey        cterm=BOLD  ctermfg=163 ctermbg=NONE
    hi StatusLine        cterm=NONE  ctermfg=118 ctermbg=235
    hi StatusLineNC      cterm=NONE  ctermfg=244 ctermbg=235
    hi TaglistTagName    cterm=BOLD  ctermfg=63  ctermbg=NONE
    hi Title             cterm=BOLD  ctermfg=124 ctermbg=NONE
    hi Type              cterm=NONE  ctermfg=207 ctermbg=NONE
    hi User1             cterm=BOLD  ctermfg=46  ctermbg=235
    hi User2             cterm=BOLD  ctermfg=63  ctermbg=235
    hi VertSplit         cterm=NONE  ctermfg=244 ctermbg=235
    hi Visual            cterm=NONE  ctermfg=231 ctermbg=61
    hi WarningMsg        cterm=BOLD  ctermfg=16  ctermbg=202
    hi WildMenu          cterm=BOLD  ctermfg=253 ctermbg=61

    if v:version >= 700
        hi Pmenu      cterm=NONE ctermfg=253  ctermbg=238
        hi PmenuSbar  cterm=NONE ctermfg=253  ctermbg=63
        hi PmenuSel   cterm=NONE ctermfg=8    ctermbg=155
        hi PmenuThumb cterm=NONE ctermfg=253  ctermbg=63

        hi MatchParen cterm=NONE ctermfg=NONE ctermbg=14
        hi SpellBad   cterm=NONE ctermfg=9    ctermbg=NONE
        hi SpellCap   cterm=NONE ctermbg=23
        hi SpellLocal cterm=NONE ctermbg=58
        hi SpellRare  cterm=NONE ctermbg=53
    endif

    hi Comment        cterm=NONE ctermfg=240 ctermbg=NONE

    hi Constant       cterm=NONE ctermfg=215 ctermbg=NONE
    hi String         cterm=NONE ctermfg=215 ctermbg=235
    hi Character      cterm=NONE ctermfg=215 ctermbg=NONE
    hi Number         cterm=NONE ctermfg=203 ctermbg=NONE
    hi Boolean        cterm=NONE ctermfg=203 ctermbg=NONE
    hi Float          cterm=NONE ctermfg=203 ctermbg=NONE

    hi Identifier     cterm=NONE ctermfg=131 ctermbg=NONE
    hi Function       cterm=NONE ctermfg=131 ctermbg=NONE

    hi Statement      cterm=NONE ctermfg=161 ctermbg=NONE
    hi Conditional    cterm=NONE ctermfg=39  ctermbg=NONE
    hi Repeat         cterm=NONE ctermfg=39  ctermbg=NONE
    hi Label          cterm=NONE ctermfg=39  ctermbg=NONE
    hi Operator       cterm=NONE ctermfg=39  ctermbg=NONE
    hi Keyword        cterm=NONE ctermfg=39  ctermbg=NONE
    hi Exception      cterm=NONE ctermfg=39  ctermbg=NONE

    hi PreProc        cterm=NONE ctermfg=35  ctermbg=NONE
    hi Include        cterm=NONE ctermfg=35  ctermbg=NONE
    hi Define         cterm=NONE ctermfg=35  ctermbg=NONE
    hi Macro          cterm=NONE ctermfg=35  ctermbg=NONE
    hi PreCondit      cterm=NONE ctermfg=35  ctermbg=NONE

    hi Type           cterm=NONE ctermfg=81  ctermbg=NONE
    hi StorageClass   cterm=NONE ctermfg=81  ctermbg=NONE
    hi Structure      cterm=NONE ctermfg=81  ctermbg=NONE
    hi Typedef        cterm=NONE ctermfg=81  ctermbg=NONE

    "hi Special        cterm=NONE ctermfg=81  ctermbg=NONE
    "hi SpecialChar    cterm=NONE ctermfg=81  ctermbg=NONE
    "hi Tag            cterm=NONE ctermfg=81  ctermbg=NONE
    "hi Delimiter      cterm=NONE ctermfg=81  ctermbg=NONE
    "hi SpecialComment cterm=NONE ctermfg=81  ctermbg=NONE
    "hi Debug          cterm=NONE ctermfg=81  ctermbg=NONE

    hi Underlined     cterm=BOLD ctermfg=227 ctermbg=NONE
    hi Ignore         cterm=NONE
    hi Error          cterm=NONE ctermfg=231 ctermbg=52
    hi Todo           cterm=BOLD ctermfg=16  ctermbg=143

else
    " Note: we never set 'term' because the defaults for B&W terminals are OK
    hi DiffAdd                                                ctermbg=LightBlue
    hi DiffChange                                             ctermbg=LightMagenta
    hi DiffDelete                        ctermfg=Blue         ctermbg=LightCyan
    hi DiffText     cterm=bold                                ctermbg=Red
    hi Directory                         ctermfg=DarkBlue
    hi ErrorMsg                          ctermfg=White        ctermbg=DarkRed
    hi FoldColumn                        ctermfg=DarkBlue     ctermbg=Grey
    hi Folded                            ctermfg=DarkBlue     ctermbg=Grey
    hi IncSearch    cterm=reverse
    hi LineNr       cterm=NONE           ctermfg=DarkGrey
    hi ModeMsg      cterm=bold           ctermbg=DarkRed
    hi MoreMsg                           ctermfg=DarkGreen
    hi NonText                           ctermfg=Blue
    hi Pmenu                                                  ctermbg=Blue
    hi PmenuSel                          ctermfg=White        ctermbg=DarkBlue
    hi Question                          ctermfg=DarkGreen
    hi Search                            ctermfg=Black        ctermbg=Red
    hi SpecialKey                        ctermfg=DarkBlue
    hi StatusLine   cterm=bold           ctermfg=Yellow       ctermbg=Blue
    hi StatusLineNC cterm=bold           ctermfg=black        ctermbg=Blue
    hi Title                             ctermfg=DarkMagenta
    hi VertSplit    cterm=reverse
    hi Visual       cterm=reverse        ctermfg=Cyan         ctermbg=NONE
    hi VisualNOS    cterm=underline,bold
    hi WarningMsg                        ctermfg=DarkRed
    hi WildMenu                          ctermfg=Black        ctermbg=Yellow

    " syntax highlighting
    hi Comment     cterm=NONE ctermfg=DarkGrey

    "hi Constant    cterm=NONE ctermfg=DarkGreen
    hi String      cterm=NONE ctermfg=Magenta
    hi Character   cterm=NONE ctermfg=Magenta
    hi Number      cterm=NONE ctermfg=DarkGreen
    hi Boolean     cterm=NONE ctermfg=DarkGreen
    hi Float       cterm=NONE ctermfg=Green

    "hi Identifier  cterm=NONE ctermfg=DarkCyan
    hi Function    cterm=NONE ctermfg=Cyan

    "hi Statement   cterm=bold ctermfg=Blue
    hi Conditional cterm=NONE ctermfg=DarkYellow
    hi Repeat      cterm=NONE ctermfg=DarkYellow
    hi Label       cterm=NONE ctermfg=DarkYellow
    hi Operator    cterm=NONE ctermfg=Red
    hi Keyword     cterm=NONE ctermfg=Red
    hi Exception   cterm=NONE ctermfg=DarkYellow

    hi PreProc     cterm=NONE ctermfg=DarkMagenta
endif
