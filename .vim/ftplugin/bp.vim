if exists("b:did_ftplugin")
  finish
endif

runtime! ftplugin/c.vim ftplugin/c_*.vim ftplugin/c/*.vim

setl ts=4 sw=4 et
