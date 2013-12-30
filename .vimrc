" Pathogen
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Plugins built-in
runtime ftplugin/man.vim
runtime macros/matchit.vim

" Encodage par défaut
set encoding=utf8

" Colorscheme & options générales d'affichage
syntax on
set background=dark
colorscheme solarized 
set cursorline
" Options solarized
let g:solarized_contrast="high"    "default value is normal
" Touche changement arrière-plan
call togglebg#map("<F3>")

" Options gvim
set guifont=Source\ Code\ Pro\ Medium\ 10
" Pas de toolbar, heading texte (bug rafraîchissement avec heading graphiques)
set guioptions-=T
set guioptions-=e
" Désactivation clignotement curseur
set guicursor+=a:blinkon0

" Souris
set mouse=a

" Leader
let mapleader=","

" Chargement auto plugin/indent language-specific
filetype plugin indent on

" Indentation
set tabstop=4
set shiftwidth=4 " Since 7.4, sw=0 sets sw to ts, but older plugins are not aware of this
set softtabstop=4
set autoindent
" Indentation C-style
autocmd FileType c,cpp,java :set cindent |
	\ :inoremap {<CR> {<CR>}<Esc><Up>o <BS>
"  <BS> permet de conserver l'indentation même après <Esc>
" } (fix highlight)

" Options programmation
autocmd FileType c,cpp,java,perl,prolog,py,sh,vim :set colorcolumn=80 number
" Activation Doxygen pour les langages supportés
let g:load_doxygen_syntax=1

" Pas d'indentation private/protected/public:, namespace, type retour,
" alignement parenthèses
set cinoptions=g0,N-s,t0,(0

" Complétion en mode Ex
set wildmode=longest,list,full

" Options recherche
set hlsearch
set incsearch
" -nH $* pour vim-latex
set grepprg=grep\ --exclude=*.swp\ --exclude=tags\ --exclude=*.taghl\ -nH\ $*
" Options pour le copier/coller
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Buffer options
set switchbuf=usetab

" Options mksession
set sessionoptions=curdir,folds,help,resize,tabpages,winsize


" Map divers
nnoremap Y			y$
nnoremap gb 		:bnext<CR>
nnoremap gB 		:bprevious<CR>

" Search for selected text, forwards or backwards.
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" Maps leader
nnoremap <Leader>dl	:lcd %:p:h<CR>
nnoremap <Leader>dg	:cd %:p:h<CR>
nnoremap <Leader>sv	:source ~/.vimrc<CR>
nnoremap <Leader>ws	:w !sudo tee %<CR>
nnoremap <Leader>n	:nohl<CR>
nnoremap <Leader>gw	:grep -Rw '<cword>' .<CR>
nnoremap <Leader>gW	:lgrep -Rw '<cword>' .<CR>
nnoremap <Leader>ms	:mksession! ~/.vim/session.vim<CR>
nnoremap <Leader>dw	:w !diff % -<CR>

" Abréviations
" http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
function! CmdCabbr(abbreviation, expansion)
  execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() 
              \ == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction

call CmdCabbr('diffs', 'vert diffsplit')
call CmdCabbr('h', 'vert rightb help')
call CmdCabbr('vsb', 'vert sbuffer')
call CmdCabbr('tsb', 'tab sbuffer')


" Commandes
" http://stackoverflow.com/a/10884567
function! MoveFile(newspec)
     let old = expand('%')
     " could be improved:
     if (old == a:newspec)
         return 0
     endif
     exe 'sav' fnameescape(a:newspec)
     call delete(old)
endfunction
command! -nargs=1 -complete=file -bar MoveFile call MoveFile('<args>')


" Manual extension-filetype associations
autocmd BufNew,BufNewFile,BufRead *.inc,*.a30 set filetype=asm
autocmd BufNew,BufNewFile,BufRead *.md set filetype=markdown


" Config plugins

" Netrw
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'

" TagHighlight
map <Leader>tr :UpdateTypesFile<CR>
if ! exists('g:TagHighlightSettings')
	let g:TagHighlightSettings={}
endif
let g:TagHighlightSettings['IncludeLocals']=1

" clang_complete
let g:clang_auto_select=1
let g:clang_complete_auto=0
let g:clang_complete_copen=0
let g:clang_snippets=1
let g:clang_conceal_snippets=1
let g:clang_trailing_placeholder=1
let g:clang_use_library=1
let g:clang_complete_macros=1
nnoremap <Leader>aq :call g:ClangUpdateQuickFix() <bar> cc <bar> clist<CR>
" Suppression preview sur complétion (inutile avec clang_complete)
set completeopt=menu,menuone,longest

" clang_indexer
nnoremap <Leader>ar :call ClangGetReferences()<CR>
nnoremap <Leader>ad :call ClangGetDeclarations()<CR>
nnoremap <Leader>as :call ClangGetSubclasses()<CR>

" Syntastic
" For setting project paths in vimrc_specific, to use with an autocmd
function! AddSyntasticClangPath(language,project_path)
	if stridx(expand('%:p'), a:project_path) == 0
		exe 'let g:syntastic_' . a:language . '_config_file="' . a:project_path . '.clang_complete""'
	endif
endfunction


" Supertab
let g:SuperTabDefaultCompletionType='context'
let g:SuperTabCompletionContexts=['s:ContextDiscover', 's:ContextText']
let g:SuperTabContextDiscoverDiscovery= 
			\ ["&completefunc:<c-x><c-u>" ,"&omnifunc:<c-x><c-o>"]
let g:SuperTabRetainCompletionDuration='completion'
let g:SuperTabLongestEnhanced=1
let g:SuperTabLongestHighlight=1
let g:SuperTabCrMapping=0 " Problème de compatibilité avec delimitMate

" Tagbar
"autocmd FileType * nested :call tagbar#autoopen(0)
let g:tagbar_compact=1
nnoremap <Leader>tt :TagbarToggle<CR>

" delimitMate
inoremap <A-a> <Plug>delimitMateS-Tab
let delimitMate_expand_space=1

" NERD commenter
let g:NERDCustomDelimiters = { 'c': { 'left': '//', 
									\ 'leftAlt': '/*', 'rightAlt': '*/' } }

" vim-latex
let g:tex_flavor='latex'

" Fugitive
nnoremap <Leader>gs :Gstatus <Bar> wincmd K<CR>
nnoremap <Leader>gt :tabe % <Bar> Gstatus <Bar> wincmd K<CR>


" Source specific
if filereadable($HOME . "/.vimrc_specific")
	source $HOME/.vimrc_specific
endif
