set background=dark
hi Normal ctermbg=Black ctermfg=White guibg=Black guifg=White

syn match   inVirusName "@[-_.a-zA-Z][-_.a-zA-Z0-9]*"
syn match   inMacroName "#[-_.a-zA-Z][-_.a-zA-Z0-9]*"
syn region  inVirus     start="{" end="}" transparent fold
syn region  inSubPtn    start="\[" end="]" transparent fold
syn match   inHexBytes  "\<[0-9a-f]*\>"
syn match   inLabel     ":\<[_a-zA-Z][-_.a-zA-Z0-9]*\>"ms=s+1
syn region  inString    start="\"" end="\"" skip="\\\""
syn match   inComment   ";.*$"
syn keyword inStackOps  push pop
syn match   inMemOps    "\<[wr][0-9a-f][0-9a-f]\>"
syn match   inMemOps    "\<[wr][0-9a-f]\>"
syn match   inMathOps   "[-+*/&|~%=]"
syn region  inLongComment   start="/\*" end="\*/"
syn keyword inJmpOps    goto nextgroup=inLabel skipwhite skipempty
syn keyword inJmpOps    jl jg je jne nextgroup=inPS skipwhite skipempty
syn match   inJmpOps    "loop\[M[0-9a-f][0-9a-f]\]" nextgroup=inLabel skipwhite skipempty
syn match   inPS        "(" nextgroup=inHexBytes skipwhite skipempty contained
syn match   inHexBytes  "\<[0-9a-f]*\>" nextgroup=inPE contained
syn match   inPE        ")" nextgroup=inLabel skipwhite skipempty contained
syn match   inLabel     "\<[_a-zA-Z][-_.a-zA-Z0-9]*\>" contained
syn keyword inBasicOps  id fmt ip ipe ipa Tee Rs vy vn vh vs T
syn keyword inCpxOps    GetFlag GetPEHeader GetCurSecVA GetSecCount RVAToOffset
syn keyword inCpxOps    LoadFileBuf LoadBuf LoadPEBuf GetBufferSize GetFileSize

syn sync match inSync grouphere NONE "[#@][-_.a-zA-Z][-_.a-zA-Z0-9]*"

hi def link inLabel     Label
hi def link inVirusName Function
hi def link inMacroName Function
hi def link inStackOps  Statement
hi def link inMemOps    Special
hi def link inMathOps   Operator
hi inOps        ctermfg=6 guifg=#60ff60
hi inCpxOps     ctermfg=2 guifg=#00ff60
hi inBasicOps   ctermfg=1 guifg=#007760
hi inJmpOps     ctermfg=5 guifg=#ff80ff
hi inLabel      ctermfg=5 cterm=underline guifg=#ff80ff gui=underline
hi def link inHexBytes  Number
hi def link inString    String
hi def link inComment   Comment
hi def link inLongComment   Comment
