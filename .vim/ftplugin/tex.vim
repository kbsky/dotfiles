" LaTeX-Box mappings
imap <buffer> <C-h>				<Plug>LatexCloseCurEnv
nmap <buffer> <LocalLeader>ln	<Plug>LatexChangeEnv
vmap <buffer> <LocalLeader>lw  	<Plug>LatexWrapSelection
vmap <buffer> <LocalLeader>lW	<Plug>LatexEnvWrapSelection

"function! s:Highlight_Matching_Pair()
"endfunction
set nocursorline
