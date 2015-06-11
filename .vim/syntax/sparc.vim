" Vim syntax file for SPARC Assembler
"
" Version : 0.2
" 
" Currently supported : V8
" 
" Please note that there is still a little problem : I cannot get the '.' and
" the ',a' sequences highlighted.
" 
" Maintainer : Nicolas Herry <k@madrognon.net>
" + major additions/modifications by Kevin Brodsky <corax26@gmail.com>


" For version 5.x: Clear all syntax items
" For version 6.0 and later: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Case insensitive
syn case ignore

syn keyword sparcTodo contained TODO

syn region sparcComment	start="/\*" end="\*/" contains=sparcTodo
syn region sparcComment	start="//" end="$" keepend contains=sparcTodo
syn match sparcComment /!.*/ contains=sparcTodo

syn match sparcRegister /%[oilrg][0-9]/
syn match sparcRegister /%fp/
syn match sparcRegister /%sp/
syn match sparcSysRegister /%psr/
syn match sparcSysRegister /%wim/
syn match sparcSysRegister /%tbr/
syn match sparcSysRegister /%asr\d\{,2}/

syn region sparcString start=/"/ skip=/\\"/ end=/"/
syn match sparcNumber /[0-9]\+/
syn match sparcNumber /\(0x\)\?\x\+/

syn match sparcIdentifier /[a-zA-Z_$][a-zA-Z0-9_$]*/
syn match sparcLabel /[A-Z0-9_\-]\+:/me=e-1


syn keyword sparcMnemonic flush ldsb ldsh ldstub ldub lduh ld ldd ldsba ldsha lduba lduha lda ldda ldstuba  nop rd sethi sll srl sra stb sth st std stba stha sta stda  swap swapa unimp wr btst bset bclr btog clr clrb clrh cmp dec deccc inc inccc mov set skipz skipnz tst ldn ldna stn stna setn setnhi casn slln srln sran clrn

syn keyword sparcMnemonicLogical  and andcc andn andcc or orcc orn orncc xnor xnorcc xor xorcc negnot 

syn keyword sparcMnemonicArithmetic add addcc addx addxcc mulscc sdiv sdivcc smul smulcc udiv udivcc umul umulcc taddcc tsubcc taddcctv tsubcctv sub subcc subx subxcc

syn keyword sparcMnemonicBranch bn be bg ble bge bl bgu bleu bcc bcs bpos bneg bvc bvs ba call jmpl save restore rett jmp fbn fbu fbg fbug fbl fblg fbne fbe fbue fbge fbuge fble fbule fbo fba cbn cb3 cb2 cb23 cb1 cb13 cb12 cb123 cb0 cb03 cb02 cb023 cb01 cb013 cb012 cba

syn match sparcMnemonicBranch /bne\(,a\)\?/

syn keyword sparcMnemonicFPI fitos fitod fitoq fstoi fdtoi fstod fstoq fdtos fdtoq fqtod fqtos fmovs fnegs fabss fsqrts fsqrtd fsqrtq fadds faddd faddq fsubs fsubd fsubq fmuls fmuld fmulq fsmulq fdivs fdivd fdivq fcmps fcmpd fcmpq fcmpes fcmped fcmpeq

syn keyword sparcMnemonicTrap tn tne te tg tle tge tl tgu tleu tlu tgeu tpos tneg tvc tvs ta

syn keyword sparcMnemonicCopro cpop1 cpop2

syn keyword sparcAsmDirective alias align ascii asciz byte common double empty file global half ident local noalias nonvolatile nword optim popsection proc pushsection quad reserve section seg single size skip stabn stabs type uahalf uaword version volatile weak word xword xstabs

" Highlight preprocessor using C syntax
syn include @c syntax/c.vim
syn match sparcPreProc /^\s*#.*/ contains=@c

syn match sparcDelimiter /[,;:]/

syn case match

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_sparc_syntax_inits")
  if version < 508
    let did_sparc_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default methods for highlighting.  Can be overridden later
  HiLink sparcTodo Todo
  HiLink sparcComment Comment
  HiLink sparcIdentifier Identifier
  HiLink sparcLabel PreProc
  HiLink sparcString String
  HiLink sparcNumber Number
  HiLink sparcDelimiter Delimiter

  HiLink sparcAsmDirective Statement

  HiLink sparcMnemonic Keyword
  HiLink sparcMnemonicLogical Operator
  HiLink sparcMnemonicArithmetic Statement
  HiLink sparcMnemonicBranch Exception
  HiLink sparcMnemonicTrap Keyword
  HiLink sparcMnemonicFPI Keyword
  HiLink sparcMnemonicCopro Keyword
  HiLink sparcMnemonicSyn Conditional

  HiLink sparcRegister Structure
  HiLink sparcSysRegister Class

  delcommand HiLink
endif

let b:current_syntax = "sparc"

let &cpo = s:cpo_save
unlet s:cpo_save
