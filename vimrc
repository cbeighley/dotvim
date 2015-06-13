" Basic configuration

set nocompatible
set encoding=utf8
set history=1000
set undolevels=1000
set hidden
set nobackup
set nowb
set noswapfile
set autoread
set magic
set wrap linebreak
set visualbell t_vb=
filetype plugin on
set incsearch
set hlsearch

" Basic visual settings
set ruler
set number
set showmatch
set background=dark

let &colorcolumn=join(range(81,999),",")
autocmd ColorScheme * highlight ColorColumn ctermbg=235 guibg=#202020

" GUI settings
set guioptions-=T
set guioptions-=l
set guioptions-=b
set gfn=Anonymous\ Pro\ 12

" Nice tab completion on command line
set wildchar=<Tab> wildmenu wildmode=full

" Ack settings for Ubuntu (ack-grep instead of ack)
"let g:ackprg="ack-grep -H --nocolor --nogroup --column"

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []

" MBE is hella slow, apparently fixed in 6.5 so try it again after release.
call add(g:pathogen_disabled, 'minibufexpl')

" Pathogen initialisation
call pathogen#infect()
call pathogen#helptags()

let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 --interaction=nonstopmode $*'
let g:Tex_TreatMacViewerAsUNIX = 1
let g:Tex_ViewRule_pdf = 'open -a Skim'

" Avoid freezing on offending code
"let g:clang_user_options='|| exit 0'
let g:clang_close_preview=1
let g:clang_snippets=1
let g:clang_conceal_snippets=1
" conceal in insert (i), normal (n) and visual (v) modes
set concealcursor=inv
 " hide concealed text completely unless replacement character is defined
set conceallevel=2

" Syntax highlighting on
syntax on

" colorscheme has to go after pathogen, it's in bundle/
colorscheme 256-jungle

" vim-hdevtools
au FileType haskell nnoremap <buffer> t :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> f :HdevtoolsClear<CR>

" GUI-like scrolling in iTerm.
set mouse=a

" Script Name: LineCommenter.vim
" Version:     2.0.0
" Last Change: Nov 12, 2008
" Author:      XSQ <xsq0304@qq.com>
"
" Description: Toggle Comment state of line.(C/C++/Java/perl/python/ruby/etc.)
" Usage:       Press '<Esc>cc' to toggle comment state of the current line
"              Press '<Esc>ncc' to toggle n straight lines.
" File Type:   Over 104 languages
"   //:        C, C++, java, javascript, etc.
"   #:         awk, makefile, perl, python, ruby, sed, sh, etc.
"   ":         vim
"   ':         asp, basic, vbscript
"   ;:         asm, ini, etc.
"   rem :      bat
"   --:        sql, etc.
"   %:         matlab, tex, etc.
" Install:     Just drop this script file into vim's plugin directory.

nmap <silent>cc :call LineCommenter()<Esc>

function GetCommenter(StringKey)
    let s:DictCommenters = {'abap':['\*',''], 'abc':['%',''], 'ada':['--',''], 'apache':['#',''], 'asm':[';',''], 'aspvbs':['''',''], 'asterisk':[';',''], 'awk':['#',''], 'basic':['''',''], 'bcpl':['//',''], 'c':['//',''], 'cecil':['--',''], 'cfg':['#',''], 'clean':['//',''], 'cmake':['#',''], 'cobol':['\*',''], 'cpp':['//',''], 'cs':['//',''], 'css':['/\*','\*/'], 'cxx':['//',''], 'd':['//',''], 'debcontrol':['#',''], 'diff':['#',''], 'dosbatch':['rem ',''], 'dosini':[';',''], 'dtml':['<!--','-->'], 'dylan':['//',''], 'e':['#',''], 'eiffel':['--',''], 'erlang':['%',''], 'euphora':['--',''], 'forth':['\',''], 'fortran':['!',''], 'foxpro':['\*',''], 'fs':['//',''], 'groovy':['//',''], 'grub':['#',''], 'h':['//',''], 'haskell':['--',''], 'hpp':['//',''], 'html':['<!--','-->'], 'htmldjango':['<!--','-->'], 'htmlm4':['<!--','-->'], 'icon':['#',''], 'io':['#',''], 'j':['NB.',''], 'java':['//',''], 'javascript':['//',''], 'lex':['//',''], 'lhaskell':['%',''], 'lilo':['#',''], 'lisp':[';',''], 'logo':[';',''], 'lua':['--',''], 'make':['#',''], 'matlab':['%',''], 'maple':['#',''], 'merd':['#',''], 'mma':['(\*','\*)'], 'modula3':['(\*','\*)'], 'mumps':[';',''], 'natural':['\*',''], 'nemerle':['//',''], 'objc':['//',''], 'objcpp':['//',''], 'ocaml':['(\*','\*)'], 'oz':['%',''], 'pascal':['{','}'], 'perl':['#',''], 'php':['//',''], 'pike':['//',''], 'pliant':['#',''], 'plsql':['--',''], 'postscr':['%',''], 'prolog':['%',''], 'python':['#',''], 'rebol':[';',''], 'rexx':['/\*','\*/'], 'ruby':['#',''], 'sas':['/\*','\*/'], 'sather':['--',''], 'scala':['//',''], 'scheme':[';',''], 'sed':['#',''], 'sgml':['<!--','-->'], 'sh':['#',''], 'sieve':['#',''], 'simula':['--',''], 'sql':['--',''], 'st':['"','"'], 'tcl':['#',''], 'tex':['%',''], 'vb':['''',''], 'verilog': ['//',''], 'vhdl':['--',''], 'vim':['"',''], 'xf86conf':['#',''], 'xhtml':['<!--','-->'], 'xml':['<!--','-->'], 'xquery':['<!--','-->'], 'xsd':['<!--','-->'], 'yacc':['//',''], 'yaml':['#',''], 'ycp':['//',''], 'yorick':['//','']}

    if has_key(s:DictCommenters, a:StringKey)
        return s:DictCommenters[a:StringKey]
    else
        return ['', '']
    endif
endfunction

function GetHeadOfLineWithSpace(Commenter)
    let s:CurrentLine = getline(".")
    let s:Words = split(s:CurrentLine, "\ ")
    let s:LengthOfCommenter = strlen(a:Commenter)
    if empty(s:Words) || strlen(s:Words[0]) != s:LengthOfCommenter - 1
        return ''
    else
        let s:WordsOfCommenter = split(a:Commenter, "\ ")
        let s:CommenterWithoutSpace = s:WordsOfCommenter[0]
        if tolower(s:CurrentLine) == s:CommenterWithoutSpace
            call setline(".", a:Commenter)
            let s:HeadOfLine = a:Commenter
        else
            let s:HeadOfLine = s:Words[0] . ' '
        endif
        return s:HeadOfLine
    endif
endfunction

function GetHeadOfLine(Commenter)
    let s:CurrentLine = getline(".")
    let s:Words = split(getline("."), "\ ")
    let s:LengthOfCommenter = strlen(a:Commenter)
    if empty(s:Words) || strlen(s:Words[0]) < s:LengthOfCommenter
        return ''
    else
        let s:HeadOfLine = ''
        let s:FirstWord = s:Words[0]
        for i in range(s:LengthOfCommenter)
            let s:HeadOfLine = s:HeadOfLine . s:FirstWord[i]
        endfor
        return s:HeadOfLine
    endif
endfunction

function LineCommenter()
    let s:ListCommenter = GetCommenter(&ft)

    if s:ListCommenter[0] == ''
        echo "." . &ft . " file is not supported."

    elseif s:ListCommenter[1] == ''
        let s:Commenter = s:ListCommenter[0]
        if s:Commenter[strlen(s:Commenter) - 1] == ' '
            let s:HeadOfLine = GetHeadOfLineWithSpace(s:Commenter)
        else
            let s:HeadOfLine = GetHeadOfLine(s:Commenter)
        endif

        let s:CurrentLine = getline(".")
        if s:HeadOfLine == s:Commenter
            let s:NewLine = substitute(s:CurrentLine, s:Commenter, "", "")
        else
            let s:NewLine = s:Commenter . s:CurrentLine
        endif
        call setline(".", s:NewLine)

    else
        echo "Block Comment has not been supported yet."
    endif
endfunction

" Tab / indentation settings
set tabstop=2
"set shiftwidth=2
"set smarttab
"set autoindent
"set smartindent
set shiftwidth=2
set softtabstop=2
set expandtab
"filetype indent on

" Backspace mapping is screwed up, so re-assign it.
set backspace=2 

