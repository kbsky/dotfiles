" Make sure we're in nocp mode
set nocompatible

" Pathogen, load all bundles
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Built-in plugins
runtime ftplugin/man.vim
runtime macros/matchit.vim

set encoding=utf-8  " Interface encoding
set backspace=2
set history=100     " More history (: commands and / patterns)

" Display options
syntax on
set cursorline
set laststatus=2    " Always show status line
set showcmd         " Show size of visual selection
set background=dark
colorscheme solarized
" Solarized options
let g:solarized_contrast = "high" " Default value is normal
" Toggle dark/light BG
call togglebg#map("<F3>")

" gvim options
set guifont=Source\ Code\ Pro\ Medium\ 10
" No toolbar, text headings (refresh bug with graphical headings? TODO)
set guioptions-=T
"set guioptions-=e
set guioptions+=e
" Disable blinking cursor
set guicursor+=a:blinkon0

" Mouse
set mouse=a

" Leader
let mapleader = ","
let maplocalleader = ","

" Chargement auto plugin/indent language-specific
filetype plugin indent on

" Indentation
set expandtab
set tabstop=4
set shiftwidth=4 " Since 7.4, sw=0 sets sw to ts, but older plugins are not aware of this
set softtabstop=4
set autoindent
" C-style indentation
autocmd FileType c,cpp,java,javascript,perl,yacc :setl cindent |
            \ :inoremap <buffer> {<CR> {<CR>}<Esc><Up>o <BS>
" " <BS>" is a hack to keep the indentation even when immediately followed by
" <Esc>
" No indentation for: private/protected/public:, namespace, return type
" Align on opening parentheses
set cinoptions=g0,N-s,t0,(0

" Language options
autocmd FileType make,php,tex :setl number
autocmd FileType arm,asm,c,cpp,java,javascript,perl,prolog,python,sh,sparc,verilog,vim,yacc
            \ :setl colorcolumn=80 number
autocmd FileType perl :setl complete-=i " Don't search in included modules (too slow)
" Text files
autocmd FileType tex,markdown
            \ :setl linebreak showbreak=-->\  cpoptions+=n

" Configure built-in syntax files
" Enable Doxygen in supported syntax files
let g:load_doxygen_syntax = 1
" Highlight bash readline extensions
let g:readline_has_bash = 1
" Use C++ syntax for lex and yacc files
let g:lex_uses_cpp = 1
let g:yacc_uses_cpp = 1

" Ex-mode completion
set wildmode=longest,list,full
" No preview on completion (useless with clang_complete)
set completeopt=menu,menuone,longest

" Search options
set hlsearch
set incsearch
" -nH $* for vim-latex
set grepprg=grep\ --exclude=*.swp\ --exclude=tags\ --exclude=*.taghl\ --exclude-dir=doxygen\ -nH\ $*

" Copy/paste options
set pastetoggle=<F2>
set showmode

" Always diff in vertical splits
set diffopt+=vertical

" Buffer options
set switchbuf=usetab

" mksession options
set sessionoptions=curdir,folds,globals,help,options,localoptions,tabpages,winsize


" Mappings
" Without this, C-c in insert mode doesn't trigger InsertLeave (useful e.g.
" in visual block insert)
inoremap <C-C>          <Esc>
nnoremap Y              y$
nnoremap gb             :bnext<CR>
nnoremap gB             :bprevious<CR>
" Make gt useful when given a count (and consistent with gT...)
nnoremap <silent> gt    :<C-U>exe 'tabnext ' . (((tabpagenr() + v:count1 - 1) % tabpagenr('$')) + 1)<CR>
" Similar to gv, but for the last pasted text
nnoremap gp             `[v`]
" Use range as the man section
nnoremap K              :<C-u>exe "Man " . v:count . " <cword>"<CR>
" Disable annoying Page Down/Up mappings
map <S-Down>            <Nop>
map <S-Up>              <Nop>

" Special mappings to clear new lines (when comments are inserted)
inoremap <S-CR>         <CR><C-u>
nnoremap <Leader>o      o<C-U>
nnoremap <Leader>O      O<C-U>

" Search for selected text, forwards or backwards
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> *     :<C-U>
            \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
            \gvy/<C-R><C-R>=substitute(
            \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
            \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> #     :<C-U>
            \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
            \gvy?<C-R><C-R>=substitute(
            \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
            \gV:call setreg('"', old_reg, old_regtype)<CR>

" Maps leader
nnoremap <Leader>dl     :lcd %:p:h<CR>
nnoremap <Leader>dg     :cd %:p:h<CR>
nnoremap <Leader>sv     :source ~/.vimrc<CR>
nnoremap <Leader>ws     :w !sudo tee %<CR>
nnoremap <Leader>n      :nohl<CR>
" gW used for git grep
nnoremap <Leader>gw     :grep -Rw '<cword>' .<CR>
nnoremap <Leader>g0w    :grep -Rw '<cword>' %:p:h<CR>
nnoremap <Leader>g1w    :exe "grep -Rw '<cword>' " . simplify(expand("%:p:h") . "/..")<CR>
nnoremap <Leader>g2w    :exe "grep -Rw '<cword>' " . simplify(expand("%:p:h") . "/../..")<CR>
nnoremap <Leader>g3w    :exe "grep -Rw '<cword>' " . simplify(expand("%:p:h") . "/../../..")<CR>
nnoremap <Leader>ms     :mksession! session.vim<CR>
nnoremap <Leader>dw     :w !diff % -<CR>
nnoremap <Leader>do     :only <Bar> diffoff!<CR>
" Switch header/source
function! SwitchHeader()
    if match(expand("%"), "\\v\\.h(pp)?$") != -1
        let src = substitute(glob(substitute(expand("%"), "\\v\\.h[^.]*$", ".c*", "")),
                    \ "\n", "", "")
        if !empty(src)
            exe "lefta vsp " . src
        else
            echo "No source found"
        endif
    elseif match(expand("%"), "\\v\.c(pp|xx)?$") != -1
        let header = substitute(glob(substitute(expand("%"), "\\v\\.c[^.]*$", ".h*", "")),
                    \ "\n", "", "")
        if !empty(header)
            exe "rightb vsp " . header
        else
            echo "No header found"
        endif
    endif
endfunction

nnoremap <Leader>sh     :call SwitchHeader()<CR>
" Retab and remove trailing whitespaces
nnoremap <Leader>cf     :%retab <Bar> %s/\s\+$//g <Bar> nohl<CR>
" Show highlight info for the item under the cursor
nnoremap <Leader>hi     :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
            \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
nnoremap <Leader>;  @:
" Call the last make command
nnoremap <Leader>ml     :make<Up><CR>

" Abbreviations
" http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
function! CmdCabbr(abbreviation, expansion)
    execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype()
            \ == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction

call CmdCabbr('diffs', 'vert diffsplit')
call CmdCabbr('h', 'vert rightb help')
call CmdCabbr('ht', 'tab help')
call CmdCabbr('vsb', 'vert sbuffer')
call CmdCabbr('tsb', 'tab sbuffer')


" Commands
" Original version: http://stackoverflow.com/a/10884567
function! MoveFile(newspec)
    let old = expand('%')
    let new = a:newspec
    if isdirectory(a:newspec)
        let new .= '/' . expand('%:t')
    endif
    try
        exe 'sav' fnameescape(simplify(new))
        call delete(old)
    endtry
endfunction
command! -nargs=1 -complete=file -bar MoveFile call MoveFile('<args>')

" http://stackoverflow.com/a/8459043
function! DeleteHiddenBuffers()
    let tpbl = []
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bdelete' buf
    endfor
endfunction
command! -nargs=0 -bar DeleteHiddenBuffers call DeleteHiddenBuffers()


" Additional highlighting links
hi link markdownCode Underlined
hi link doxygenVerbatimRegion Underlined
hi! link vimIsCommand Identifier
" Override adaSpecial highlighting (mainly highlights delimiters)
hi link adaSpecial Delimiter


" Config plugins

" Netrw
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" TagHighlight
map <Leader>tr :UpdateTypesFile<CR>
if ! exists('g:TagHighlightSettings')
    let g:TagHighlightSettings = {}
endif
let g:TagHighlightSettings['IncludeLocals'] = 1
" Ctags isn't aware of override (C++11), ignore it
let g:TagHighlightSettings['CtagsExtraArguments'] = ['-Ioverride']
let g:TagHighlightSettings['LanguageDetectionMethods'] = ['FileType']
" Looks weird otherwise
hi! link CTagsConstant EnumerationValue
" taghl files use vim syntax
autocmd BufNew,BufNewFile,BufRead *.taghl set filetype=vim

" clang_complete
let g:clang_auto_select = 1
let g:clang_complete_auto = 0
let g:clang_complete_copen = 0
let g:clang_snippets = 1
let g:clang_trailing_placeholder = 1
let g:clang_use_library = 1
let g:clang_complete_macros = 1
let g:clang_complete_patterns = 1
nnoremap <Leader>aq :call g:ClangUpdateQuickFix() <bar> cc <bar> clist<CR>

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
" Default is Todo, too close to Error
hi! link SyntasticWarningSign Underlined
" Default LaTeX checker is a pain in the ass, use chktex instead
let syntastic_tex_checkers = ['chktex']
" Default C/C++ options
let syntastic_c_check_header = 1
let syntastic_cpp_check_header = 1
let syntastic_c_compiler_options = '-std=gnu99 -Wall -Wextra'
let syntastic_cpp_compiler_options = '-std=c++1y -Wall -Wextra'

" Supertab
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = "<c-n>"
let g:SuperTabCompletionContexts = ['s:ContextDiscover', 's:ContextText']
let g:SuperTabContextDiscoverDiscovery =
            \ ["&omnifunc:<c-x><c-o>", "&completefunc:<c-x><c-u>"]
let g:SuperTabRetainCompletionDuration = 'completion'
let g:SuperTabLongestEnhanced = 1
" TODO: should be 1, currently broken, ref https://github.com/ervandew/supertab/issues/158
let g:SuperTabLongestHighlight = 0
let g:SuperTabCrMapping = 0 " Compatbility issue with delimitMate

" Tagbar
"autocmd FileType * nested :call tagbar#autoopen(0)
let g:tagbar_compact = 1
nnoremap <Leader>tt :TagbarToggle<CR>

" delimitMate
imap <C-f> <Plug>delimitMateS-Tab
imap <C-b> <Plug>delimitMateJumpMany
let delimitMate_expand_space = 1

" NERD commenter
let g:NERDCustomDelimiters = { 'c': { 'left': '//',
                                \ 'leftAlt': '/*', 'rightAlt': '*/' } }
let g:NERDSpaceDelims = 1

" vim-latex
let g:tex_flavor = 'latex'

" Fugitive
nnoremap <Leader>gs :Gstatus <Bar> wincmd K<CR>
nnoremap <Leader>gt :tabe % <Bar> Gstatus <Bar> wincmd K<CR>
nnoremap <Leader>gd :Gdiff<CR>
" gw used for plain grep
nnoremap <Leader>gW :Ggrep -w '<cword>' .<CR>

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_solarized_normal_green = 1

" Jedi
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0

let g:jedi#completions_command = ''
let g:jedi#goto_assignments_command = '<C-]>'
let g:jedi#goto_definitions_command = '<Leader>jd'
let g:jedi#rename_command = '<Leader>jr'
let g:jedi#usages_command = '<Leader>ju'

" LaTeX Box
let g:LatexBox_Folding = 1
let g:LatexBox_fold_envs = 1
let g:LatexBox_fold_automatic = 0

" javacomplete2
" We need to be very explicit if the default SDK is not JDK8
let s:java_home = empty($JAVA_HOME) ? "/usr/lib/jvm/java-8-openjdk" : $JAVA_HOME
let g:java_classpath = s:java_home . "/lib"
let g:JavaComplete_JvmLauncher = s:java_home . "/bin/java"
let g:JavaComplete_JavaCompiler = s:java_home . "/bin/javac"

" logcat
hi! logcatLevelFatal guifg=Red gui=bold ctermfg=Red term=bold

" neoman
let g:neoman_tab_after = 1


" Source specific
if filereadable($HOME . "/.vimrc_specific")
    source $HOME/.vimrc_specific
endif

" vim: set ts=4 sw=4 sts=4 et:
