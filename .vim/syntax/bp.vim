if exists("b:current_syntax")
  finish
endif

" TODO: use something a bit more appropriate
runtime! syntax/c.vim

let b:current_syntax = "bp"
