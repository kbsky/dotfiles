" javacomplete2
setl omnifunc=javacomplete#Complete
nmap <buffer> <LocalLeader>ja <Plug>(JavaComplete-Imports-Add)
nmap <buffer> <LocalLeader>jm <Plug>(JavaComplete-Imports-AddMissing)
nmap <buffer> <LocalLeader>jr <Plug>(JavaComplete-Imports-RemoveUnused)
