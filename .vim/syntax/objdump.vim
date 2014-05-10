" Vim syntax file
" Language:	Mixed C and Assembly GCC objdump disassembly format.
" Maintainer:	Vihar Rai   oxcrete@yahoo.com
" Last Change:	2014 May 10 by Kevin Brodsky
" Version:      0.2
" File Names:   Anything you want
" Comment:      gcc -g -c xxx.c             /*output is xxx.o*/
"               objdump -S xxx.o > xxx.dis  /* creates disassembly mixed with source */
"               It does not recognize any opcodes, so it's processor independent.
"
" Changed in 0.2:
" * Actually highlight cMixAsm using an ASM syntax
" * Link cMixLabel to Underlined (better than DiffDelete with Solarized,
"   change according to your tastes)
"
" b:asmsyntax (or the global version) must be defined to the desired ASM syntax
" (e.g. nasm), a nice way to do this is to use another syntax file that
" defines b:asmsyntax and includes this file (using runtime)


" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
" As a result, all lines use C syntax, except those matched by a specific
" cMix* group
if version < 600
  so <sfile>:p:h/c.vim
else
  runtime! syntax/c.vim
  unlet b:current_syntax
endif

" See s:FTasm in built-in filetype.vim
if exists("b:asmsyntax")
	" Use the buffer-specific ASM syntax
	let s:asm_flavor = b:asmsyntax
elseif exists("g:asmsyntax")
	" Use the global ASM syntax
	let s:asm_flavor = g:asmsyntax
else
	" Use GNU assembler as fallback
	let s:asm_flavor = "asm"
endif

" Use determined ASM syntax
exe "syn include @asm syntax/" . fnameescape(s:asm_flavor) . ".vim"


" Match the labels and Assembly lines
syn match       cMixLabel                "^\x\+\s\+<.*>:$"
syn match       cMixAsm                  "^\s*\x\+:\s\+\x\+.*$" contains=@asm

"------------------------------------------------------------------
"   GUIDE
"
"  First Token breakdown
"  00000084 <_main>:
"
"       ^       Beginning of line
"       \x\+    one or more hex
"       \s\+    one or more space
"       <.*>    zero or more characters enclosed within < >
"       :       literally :
"       $       End of Line.
"
"  Second Token breakdown
"  75:	69 64 0a 00 49 6e 76	imul   $0x61766e49,0x0(%edx,%ecx,1),%esp
"
"       ^       Beginning of line
"       \s*     zero or more spaces
"       \x\+    one or more hex digit
"       :       literally ":"
"       \s\+    one or more space
"       \x\+    one or more hex
"       $       EOL
"-------------------------------------------------------------------

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_cmix_syn_inits")
  if version < 508
    let did_cmix_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cMixLabel               Underlined
  delcommand HiLink
endif

let b:current_syntax = "objdump"

" vim: ts=8
