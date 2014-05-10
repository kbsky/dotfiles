" Vim syntax file
" Language:	C Additions
" Maintainer:	Mikhail Wolfson <mywolfson@gmail.com>
" URL: http://web.mit.edu/wolfsonm
" Last Change:	2010 Dec. 3
" Version: 0.4
"
" Changelog:
"   0.4 - updates and fixes to cDelimiter to fix break with foldmethod=syntax,
"         entirely suggested and solved by Ivan Freitas
"         <ivansichfreitas@gmail.com>
"   0.3 - updates and fixes to cUserFunctionPointer, thanks to
"         Alexei <lxmzhv@gmail.com>
"   0.2 - change [] to operator
"   0.1 - initial upload, modification from vimscript#1201, Extended c.vim
"
" /!\ Cut down version: only operators/delimiters (with improved matches)

" Operators
syn match cOperator	"[.!~*&%<>^|=:?,+-]"
syn match cOperator	"/[^/*=]"me=e-1

" Delimiters
syn match cDelimiter    "[();,\\\][]"
" foldmethod=syntax fix, courtesy of Ivan Freitas
syn match cBraces display "[{}]"

" Links
hi def link cDelimiter Delimiter
hi def link cBraces Delimiter
