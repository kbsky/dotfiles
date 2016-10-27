" LaTeX-Box mappings
imap <buffer> <C-h>             <Plug>LatexCloseCurEnv
nmap <buffer> <LocalLeader>ln   <Plug>LatexChangeEnv
vmap <buffer> <LocalLeader>lw   <Plug>LatexWrapSelection
vmap <buffer> <LocalLeader>lW   <Plug>LatexEnvWrapSelection

" Prevent lag from function s:Highlight_Matching_Pair()
" setl nocursorline
" Moving files around doesn't work well when using latexmk -pvc (vim cannot
" remove the backup file as latexmk has it opened)
setl nowritebackup
