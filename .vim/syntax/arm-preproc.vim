if exists("b:current_syntax")
  finish
endif

runtime! syntax/arm.vim
unlet b:current_syntax

syn include @preproc syntax/c.vim
syn match armPreproc "^\s*#.*" contains=@preproc

let b:current_syntax = "arm-preproc"
