runtime colors/solarized8.vim

let g:colors_name = 'solarized8_custom'

" Corax's add-on: Moar color "{{{
" ---------------------------------------------------------------------

if &background == "dark"
    hi! Operator    guifg=#93b84a ctermfg=107
    hi! Delimiter   guifg=#bbbb55 ctermfg=143
else
    hi! Operator    guifg=#54701D ctermfg=66
    hi! Delimiter   guifg=#956A0C ctermfg=94
endif

"}}}
" Corax's add-on 2: TagHighlight "{{{
" ---------------------------------------------------------------------

hi! Class           guifg=#875fd7 ctermfg=98
hi! link Interface Class
hi! Structure       guifg=#8787ff ctermfg=105
hi! Type            guifg=#0087ff ctermfg=33
hi! Union           guifg=#af005f ctermfg=125
hi! link EnumerationName Type
hi! link EnumeratorName  Type
if &background == "dark"
    hi! Namespace   guifg=#00ffd7 ctermfg=50
else
    hi! Namespace   guifg=#0000d7 ctermfg=20
endif
hi! link Package Namespace
hi! link Import Namespace

hi! EnumerationValue guifg=#00afff ctermfg=39
hi! link GlobalConstant EnumerationValue
hi! DefinedName     guifg=#d75f00 ctermfg=166
if &background == "dark"
    hi! Member      guifg=#d7af00 ctermfg=178
    hi! LocalVariable guifg=#5fd75f ctermfg=77
    hi! GlobalVariable guifg=#d700af ctermfg=163
else
    hi! Member      guifg=#5f5f00 ctermfg=58
    hi! LocalVariable guifg=#008700 ctermfg=28
    hi! GlobalVariable guifg=#af0087 ctermfg=163
endif
hi! link Field Member
hi! link Extern GlobalVariable

hi! Identifier      guifg=#0087af ctermfg=31
hi! link Function Identifier
hi! link Method Identifier

"}}}
" Corax's add-on 3: Tagbar "{{{
" ---------------------------------------------------------------------

if &background == "dark"
    hi! TagbarVisibilityPublic guifg=#00ff00 ctermfg=46
    hi! TagbarVisibilityProtected guifg=#00d7ff ctermfg=45
    hi! TagbarVisibilityPrivate guifg=#d70000 ctermfg=160
else
    hi! TagbarVisibilityPublic guifg=#00af00 ctermfg=34
    hi! TagbarVisibilityProtected guifg=#005fff ctermfg=27
    hi! TagbarVisibilityPrivate guifg=#ff0000 ctermfg=196
endif

"}}}
