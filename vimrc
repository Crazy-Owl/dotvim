" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

language messages en_US.UTF-8
let vimfiles_dir=expand("$HOME/.vim/")

filetype on
if filereadable(vimfiles_dir."autoload/pathogen.vim")
    call pathogen#helptags()
    call pathogen#runtime_append_all_bundles()
    call pathogen#infect()
endif
filetype plugin indent on
" filetype plugin on

set modeline
set modelines=3

set ttyfast
set gdefault

au BufRead,BufNewFile *.rs    set filetype=rust

if version >= 703
    set undofile
endif
set undodir=$HOME/.vimbackup
set formatoptions=croql
set cinoptions=l1,g0,p0,t0,c0,(s,U1,m1

" save all at focus lost
au FocusLost * silent! wa

set backup      " keep a backup file
set backupdir=$HOME/.vimbackup
set history=250     " keep 250 lines of command line history
set ruler           " show the cursor position all the time

" Don't use Ex mode, use Q for formatting
map Q gq

set number
"set relativenumber

"let g:solarized_termcolors=16
"let g:solarized_termtrans=0
"let g:solarized_degrade=0
syntax enable
set hlsearch
set background=dark
if has('gui_running')
    colorscheme molokai
else
    colorscheme evening
endif

set listchars=tab:»\ ,trail:·,eol:¶

" по умолчанию поиск латиницей
set imsearch=0
set tabstop=4
set shiftwidth=4
set autoindent smartindent
set softtabstop=4
"set smarttab
set expandtab
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" граница переноса
set wrapmargin=5
" подсветим 85ю колонку
"if version >= 703
    "set colorcolumn=85
"endif
" автоматический перенос после 128 колонки
set textwidth=128
" сколько строк повторять при скроллинге
set scrolloff=4
" подсветка строки и колонки курсора
if version >= 700
    set cursorline
endif
"set cursorcolumn
"set visualbell
" миннимальная высота окна
"set winminheight=4
" делать активное окон максимального размера
"set noequalalways
"set winheight=999

set incsearch        " do incremental searching
set ignorecase
set smartcase


set hidden          " не выгружать буфер когда переключаешься на другой
if has("mouse")
    set mouse=         " выключает поддержку мыши при работе в терминале (без GUI)
    set mousehide       " скрывать мышь в режиме ввода текста
endif
set showcmd         " показывать незавершенные команды в статусбаре (автодополнение ввода)
set matchpairs+=<:> " показывать совпадающие скобки для HTML-тегов
set showmatch       " показывать первую парную скобку после ввода второй
set autoread        " перечитывать изменённые файлы автоматически
set confirm         " использовать диалоги вместо сообщений об ошибках

" Автоматически перечитывать конфигурацию VIM после сохранения
autocmd! BufWritePost $MYVIMRC source $MYVIMRC

" Прыгать на последнюю позицию при открытии буфера
autocmd! BufReadPost * call LastPosition()
"
function! LastPosition()
    " не меняем позицию при коммите 
    if expand("<afile>:s? \d+??") != '.git\COMMIT_EDITMSG'
        if expand("<afile>:t") != ".git" && line("'\"")<=line('$')
            normal! `"
        endif
    endif
endfunction
if version >= 700
    " опции сессий - перейти в текущию директорию, использовать буферы и табы
    set sessionoptions=curdir,buffers,help,options,resize,slash,tabpages,winpos,winsize 
else
    set sessionoptions=curdir,buffers,help,options,resize,slash,winpos,winsize
endif


" Для указанных типов файлов отключает замену табов пробелами и меняет ширину отступа
au FileType crontab,fstab,make set noexpandtab tabstop=8 shiftwidth=8

"" Применять типы файлов
filetype on
filetype plugin on
filetype indent on
" Если сохраняемый файл является файлом скрипта - сделать его исполняемым
au BufWritePost * if getline(1) =~ "^#!.*/bin/.*sh"|silent !chmod a+x %|endif

set wildignore+=*.pyc,*.o

"" Переключение кодировок файла
set wildmenu
set wcm=<Tab>
menu Encoding.CP1251   :e ++enc=cp1251<CR>
menu Encoding.CP866    :e ++enc=cp866<CR>
menu Encoding.KOI8-U   :e ++enc=koi8-u<CR>
menu Encoding.UTF-8    :e ++enc=utf-8<CR>
map <F8> :emenu Encoding.<TAB>

set lazyredraw

"set encoding=cp1251
"set termencoding=utf-8
set fileencodings=utf-8,cp1251,koi8-r,cp866
set fileformats=unix,dos,mac " формат файла по умолчанию (влияет на окончания строк) - будет перебираться в указанном порядке

" Ловля имени редактируемого файла из vim'а. (^[ вводится как Ctrl+V Esc)
set title
"set titlestring=%t-dsd
"set titleold=&titlestring
" screen:
"set titlestring=%t
"set titleold=bash
let &titlestring = "vim (" . expand("%:t") . ")"
if &term == "screen"
    set t_ts=k
    set t_fs=\
endif
if &term == "screen" || &term == "xterm"
    set title
endif

autocmd! BufEnter * call NextTabOpened()
"
function! NextTabOpened()
    let &titlestring = "vim (" . expand("%:t") . ")"
endfunction

" сохраняемся по F2
nmap <F2> <ESC>:w<CR>
imap <F2> <ESC>:w<CR>i<Right>
nmap <F3> <ESC>:nohlsearch<CR>
imap <F3> <ESC>:nohlsearch<CR>
" F6/F7 - предыдущая/следующая ошибка
nmap <F6> <ESC>:cp<CR>
imap <F6> <ESC>:cp<CR>
nmap <F7> <ESC>:cn<CR>
imap <F7> <ESC>:cn<CR>

nmap <F10> <ESC>:w !sudo tee %<CR>

" ?
"inoremap <silent> <C-u> <ESC>u:set paste<CR>.:set nopaste<CR>gi

set statusline=%f\ %L%y%r\ [%{&ff}][%{&fenc}]\ %=%m\ %-15(0x%02B\ (%b)%)%-15(%l,%c%V%)%P  
" %{GitBranch()} 
set laststatus=2

" tab navigation like firefox
if version >= 700
    nmap Z :tabprev<cr>
    nmap X :tabnext<cr>
endif

" хранить swap-файлы будем в одном месте, чтобы не мешались
let swap_dir='/home/owl/.swapfiles/'

if !isdirectory(swap_dir) && exists('*mkdir')
    call mkdir(swap_dir)
endif

if isdirectory(swap_dir)
    let &directory=swap_dir.'/'
endif

"set noswapfile

"highlight SpellBad  ctermbg=blue

"GIT GREP
func! GitGrep(...)
    let save = &grepprg
    set grepprg=git\ grep\ -n\ $*
    let s = 'grep'
    for i in a:000
        let s = s . ' ' . i
    endfor
    exe s
    let &grepprg = save
endfun
command! -nargs=? G call GitGrep(<f-args>)

func! GitGrepWord()
    normal! "zyiw
    call GitGrep('-w -e ', getreg('z'))
endf
nmap <C-x>G :call GitGrepWord()<CR>
"let g:khuno_ignore="W191,E501,E303,E123,E241,E121,E122,E221,E242,E128,E225"



" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
    let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction

function! ToggleIndent()
    if !search('^\t', 'nw')
        Space2Tab
   endif
endf

" au FileType python,javascript call ToggleIndent()
" Activate auto filetype detection
set pastetoggle=<F6>    " F6 toggles paste mode


au BufNewFile,BufRead *.txt setf text
au FileType text set wrap 

map <LocalLeader>cs :%s/\s\+$//e<CR>

:set guioptions-=m  "remove menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar

" plugin settings

" pyflakes

" do not use quickfix with pyflakes
"let g:pyflakes_use_quickfix = 0

" flake8

" ignore white space of empty line warning for flake8
"let g:flake8_ignore="W293"
"let g:flake8_max_line_length=99
" autorun flake8 on save
"autocmd BufWritePost *.py call Flake8()

" pathogen

call pathogen#infect()
call pathogen#helptags()

" NERDTree

" ignore in NERDTree files that end with pyc and ~
let NERDTreeIgnore=['\.pyc$', '\~$']


" flavored-markdown
" https://github.com/jtratner/vim-flavored-markdown
augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown,*.md.in setlocal filetype=ghmarkdown
augroup END


" abbreviate for Python pdb
abb pdb; import pdb; pdb.set_trace()

"
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Bi-directional find motion
" " Jump to anywhere you want with minimal keystrokes, with just one key binding.
" " `s{char}{label}`
nmap <Leader>e <Plug>(easymotion-s)
" " or
" " `s{char}{char}{label}`
" " Need one more keystroke, but on average, it may be more comfortable.
" nmap s <Plug>(easymotion-s2)
"
" " Turn on case sensitive feature
let g:EasyMotion_smartcase = 1
"
" " JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)"

" syntastic python
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_args='--ignore=E211,E261,E501,E302,E251,E262,E221,E265,E128,F403,E124,E241'
let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs=1

" vim-clojure-static settings
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let']
let g:clojure_fuzzy_indent_blacklist = ['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_align_multiline_strings = 1 " align multiline strings

" rainbow parentheses settings
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
