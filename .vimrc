" Pathogen
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Thème coloration
syntax on
set background=dark
colorscheme solarized 
" Options solarized
let g:solarized_contrast="high"    "default value is normal
" Touche changement arrière-plan
call togglebg#map("<F3>")

" Options gvim
set guifont=Source\ Code\ Pro\ Medium\ 10
" Pas de toolbar, heading texte (bug rafraîchissement avec heading graphiques)
set guioptions-=Te

" Leader
let mapleader = ","

" Indentation
set tabstop=4
set shiftwidth=4
set autoindent
" Indentation C-style
autocmd FileType c,cpp,java :set cindent
" Options programmation
autocmd FileType c,cpp,java,py :set colorcolumn=80 number
" Pas d'indentation private/protected/public:, namespace, type retour
set cinoptions=g0,N0,t0

" Options recherche
set incsearch
" Options pour le copier/coller
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" help en vsplit
augroup helpfiles
  au!
  au BufRead,BufEnter */doc/* wincmd L
augroup END

" Map divers
map <Leader>cl :lcd %:p:h<CR>
map <Leader>cg :cd %:p:h<CR>


" Plugins

" Plugin man
source $VIMRUNTIME/ftplugin/man.vim

" TagHighlight
map <Leader>tr :UpdateTypesFile<CR>
if ! exists('g:TagHighlightSettings')
	let g:TagHighlightSettings = {}
endif
let g:TagHighlightSettings['IncludeLocals']=1

" vim-latex
filetype plugin on
filetype indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
