" Pathogen
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Encodage par défaut
set encoding=utf8

" Colorscheme
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
set guioptions-=T
set guioptions-=e

" Leader
let mapleader = ","

" Pour être sûr
filetype plugin on

" Indentation
set tabstop=4
set shiftwidth=4
set autoindent
" Indentation C-style
autocmd FileType c,cpp,java :set cindent
" Options programmation
autocmd FileType c,cpp,java,py,sh :set colorcolumn=80 number
" Pas d'indentation private/protected/public:, namespace, type retour
set cinoptions=g0,N0,t0

" Complétion en mode Ex
set wildmode=longest,list,full

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
nnoremap <Leader>dl :lcd %:p:h<CR>
nnoremap <Leader>dg :cd %:p:h<CR>
nnoremap <Leader>v :source ~/.vimrc<CR>
nnoremap <Leader>ws :w !sudo tee %<CR>
nnoremap <Leader>n :noh<CR>

inoremap <C-Space> <Esc>


" Plugins

" Plugin man
source $VIMRUNTIME/ftplugin/man.vim

" TagHighlight
map <Leader>tr :UpdateTypesFile<CR>
if ! exists('g:TagHighlightSettings')
	let g:TagHighlightSettings={}
endif
let g:TagHighlightSettings['IncludeLocals']=1

" clang_complete
let g:clang_auto_select=1
let g:clang_complete_auto=0
let g:clang_complete_copen=1
let g:clang_snippets=1
let g:clang_conceal_snippets=1
let g:clang_trailing_placeholder=1
let g:clang_use_library=1
let g:clang_complete_macros=1
nnoremap <Leader>aq :call g:ClangUpdateQuickFix()<CR>
" clang_indexer
nnoremap <Leader>ar :call ClangGetReferences()<CR>
nnoremap <Leader>ad :call ClangGetDeclarations()<CR>
nnoremap <Leader>as :call ClangGetSubclasses()<CR>
" Suppression preview sur complétion (inutile avec clang_complete)
set completeopt=menu,menuone,longest

" Supertab
let g:SuperTabDefaultCompletionType='context'
let g:SuperTabCompletionContexts=['s:ContextDiscover', 's:ContextText']
let g:SuperTabContextDiscoverDiscovery= 
			\ ["&completefunc:<c-x><c-u>" ,"&omnifunc:<c-x><c-o>"]
let g:SuperTabRetainCompletionDuration='completion'
let g:SuperTabLongestEnhanced=1
let g:SuperTabLongestHighlight=1

" Tagbar
autocmd FileType * nested :call tagbar#autoopen(0)
let g:tagbar_compact=1
nnoremap <Leader>tt :TagbarToggle<CR>

" vim-latex
filetype plugin on
filetype indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
