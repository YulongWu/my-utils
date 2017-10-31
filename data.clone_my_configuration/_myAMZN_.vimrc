
" Vundle {{{
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugin 'altercation/vim-colors-solarized'

Plugin 'AutoClose'

Plugin 'vim-scripts/python.vim'

" Plugin 'vim-scripts/pig.vim'
Plugin 'motus/pig.vim'

Plugin 'autowitch/hive.vim'

"Plugin 'powerline/powerline'
Plugin 'Lokaltog/vim-powerline'

Plugin 'scrooloose/nerdcommenter'

call vundle#end()

filetype plugin indent on
" }}}

" Following .vimrc comes from this tutorial: http://dougblack.io/words/a-good-vimrc.html
" Colors {{{
syntax enable           " enable syntax processing
" set background=dark
" colorscheme solarized
" colorscheme badwolf
" }}}
" Spaces & Tabs {{{
set tabstop=4           "number of visual spaces per TAB:  4 space tab
set expandtab           " use spaces for tabs
set softtabstop=4       " number of spaces in tab when editing: 4 space tab
set shiftwidth=4
set modelines=1
" filetype indent on      " load filetype-specific indent files
" filetype plugin on
set autoindent
" }}}
" UI Layout {{{
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set wildmenu            " visual autocomplete for command menu
"set lazyredraw         " redraw only when we need to: lead to faster macro
set showmatch           " higlight matching parenthesis
" }}}
" Searching {{{
set ignorecase          " ignore case when searching
set incsearch           " search as characters are entered
set hlsearch            " highlight all matches
" }}}
" Folding {{{
"=== folding ===
set foldmethod=marker   " fold based on indent level
set foldnestmax=99      " max 10 depth
set foldenable          " don't fold files by default on open
nnoremap <space> za     " space open/closes folds
set foldlevelstart=10    " start with fold level of 1
" }}}
" Line Shortcuts {{{
nnoremap j gj
nnoremap k gk
"nnoremap B ^
"nnoremap E $
" nnoremap $ <nop>
" nnoremap ^ <nop>
nnoremap gV `[v`]       " It visually selects the block of characters you added last time you were in INSERT mode.
" xnoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
" onoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
" xnoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
"  
" onoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
" xnoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
" onoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
" xnoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
" }}}
" Leader Shortcuts {{{
let mapleader=","
" nnoremap <leader>m :silent make\|redraw!\|cw<CR>
" nnoremap <leader>w :NERDTree<CR>
nnoremap <leader>u :GundoToggle<CR>
" nnoremap <leader>h :A<CR>
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>l :call ToggleNumber()<CR>
nnoremap <leader><space> :noh<CR>
nnoremap <leader>s :mksession<CR>       " save a given assortment of windows so that they're there next time you open up Vim with "vim -S"
" nnoremap <leader>a :Ag      " vim plugin ag.vim, fantastic command line tool to search source code in a project.
" nnoremap <leader>c :SyntasticCheck<CR>:Errors<CR>
nnoremap <leader>1 :set number!<CR>
" nnoremap <leader>d :Make! 
" nnoremap <leader>r :call RunTestFile()<CR>
" nnoremap <leader>g :call RunGoFile()<CR>
" vnoremap <leader>y "+y
" vmap v <Plug>(expand_region_expand)
" vmap <C-v> <Plug>(expand_region_shrink)
inoremap jk <esc>
" }}}
" Powerline {{{
"set encoding=utf-8
"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
set laststatus=2
" }}}
" CtrlP {{{
" let g:ctrlp_match_window = 'bottom,order:ttb'
" let g:ctrlp_switch_buffer = 0
" let g:ctrlp_working_path_mode = 0
" let g:ctrlp_custom_ignore = '\vbuild/|dist/|venv/|target/|\.(o|swp|pyc|egg)$'
" }}}
" NERDTree {{{
" let NERDTreeIgnore = ['\.pyc$', 'build', 'venv', 'egg', 'egg-info/', 'dist', 'docs']
" }}}
" Syntastic {{{
" let g:syntastic_python_flake8_args='--ignore=E501'
" let g:syntastic_ignore_files = ['.java$']
" }}}
"" Tmux {{{
"if exists('$TMUX') " allows cursor change in tmux mode
"    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"else
"    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"endif
"" }}}
" MacVim {{{
" set guioptions-=r 
" set guioptions-=L
" }}}
" AutoGroups {{{
" This is a slew of commands that create language-specific settings for certain filetypes/file extensions.
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md,*.rb :call <SID>StripTrailingWhitespaces()
    autocmd BufEnter *.cls setlocal filetype=java
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
augroup END
" }}}
" Backups {{{
set backup 
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp 
set backupskip=/tmp/*,/private/tmp/* 
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp 
set writebackup
" }}}
" Custom Functions {{{
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" function! RunTestFile()
"     if(&ft=='python')
"         exec ":!" . ". venv/bin/activate; nosetests " .bufname('%') . " --stop"
"     endif
" endfunction
" 
" function! RunGoFile()
"     if(&ft=='go')
"         exec ":new|0read ! go run " . bufname('%')
"     endif
" endfunction

" function! RunTestsInFile()
"     if(&ft=='php')
"         :execute "!" . "/Users/dblack/pear/bin/phpunit -d memory_limit=512M -c /usr/local/twilio/src/php/tests/config.xml --bootstrap /usr/local/twilio/src/php/tests/bootstrap.php " . bufname('%') . ' \| grep -v Configuration \| egrep -v "^$" '
"     elseif(&ft=='go')
"         exec ":!gp test"
"     elseif(&ft=='python')
"         exec ":read !" . ". venv/bin/activate; nosetests " . bufname('%') . " --nocapture"
"     endif
" endfunction

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

" function! <SID>CleanFile()
"     " Preparation: save last search, and cursor position.
"     let _s=@/
"     let l = line(".")
"     let c = col(".")
"     " Do the business:
"     %!git stripspace
"     " Clean up: restore previous search history, and cursor position
"     let @/=_s
"     call cursor(l, c)
" endfunction
 
function! s:NextTextObject(motion, dir)
  let c = nr2char(getchar())
 
  if c ==# "b"
      let c = "("
  elseif c ==# "B"
      let c = "{"
  elseif c ==# "r"
      let c = "["
  endif
 
  exe "normal! ".a:dir.c."v".a:motion.c
endfunction
" }}}
" for hive.vim {{{
" for .hql files
au BufNewFile,BufRead *.hql set filetype=hive expandtab

" for .hive files
au BufNewFile,BufRead *.hive set filetype=hive expandtab
" }}}
" for powerline {{{
"set rtp+=/Library/Python/2.7/site-packages/powerline/bindings/vim

"" These lines setup the environment to show graphics and colors correctly.
"set nocompatible
"set t_Co=256
 
"let g:minBufExplForceSyntaxEnable = 1
"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup
 
"if ! has('gui_running')
   "set ttimeoutlen=10
   "augroup FastEscape
      "autocmd!
      "au InsertEnter * set timeoutlen=0
      "au InsertLeave * set timeoutlen=1000
   "augroup END
"endif
 
"set laststatus=2 " Always display the statusline in all windows
"set guifont=Inconsolata\ for\ Powerline:h14
"set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
" }}}
" for line swaping from "http://stackoverflow.com/questions/741814/move-entire-line-up-and-down-in-vim" {{{
function! s:swap_lines(n1, n2)
    let line1 = getline(a:n1)
    let line2 = getline(a:n2)
    call setline(a:n1, line2)
    call setline(a:n2, line1)
endfunction

function! s:swap_up()
    let n = line('.')
    if n == 1
        return
    endif

    call s:swap_lines(n, n - 1)
    exec n - 1
endfunction

function! s:swap_down()
    let n = line('.')
    if n == line('$')
        return
    endif

    call s:swap_lines(n, n + 1)
    exec n + 1
endfunction

noremap <silent> <leader><up> :call <SID>swap_up()<CR>
noremap <silent> <leader><down> :call <SID>swap_down()<CR>
" }}}
