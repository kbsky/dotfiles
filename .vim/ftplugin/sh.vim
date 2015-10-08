" Center and surround with #'s a title (removing trailing spaces and #'s)
nmap <buffer> <LocalLeader>bc :s/\v^[#[:space:]]*(.{-})[#[:space:]]*$/\1/<Bar>center<Bar>s/ \w\@!/#/g<Bar>nohl<CR>^"myeA <Esc>"mp
