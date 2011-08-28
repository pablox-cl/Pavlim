""
"" Customizations
""

" TODO
"let s:current_file = expand("<sfile>:p")

"function s:add_group(name)
"  let resolved = resolve(s:current_file)
"  let dir = fnamemodify(resolved, ":h")
"  let file = dir . "/" . a:name
"  call pathogen#runtime_prepend_subdirectories(file)
"endfunction

" Include user's local vim config
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

""
"" Pathogen setup
""

call pathogen#infect()
" TODO
" call s:add_group("name-a-group-here")

""
"" Basic configuration
""

set encoding=utf-8
set backup                            " Enable backup
set nocompatible                      " Don't try to be strictly vi-like
set modeline
set modelines=10                      " Use modeline overrides
set viminfo='20,\"50                  " Use a viminfo file,...
set history=50                        " Limit history
set ruler                             " Show the cursor position
set title                             " Show title
set t_Co=256                          " Uses 256 colors
set laststatus=2                      " Always show status bar
set showcmd                           " Show command in bottom right portion of the screen
set showmatch                         " Show matching brackets
set splitbelow                        " Split windows below the current window
set colorcolumn=+3                    " Displays a vertical column added/substraced from textwidth (>= Vim 7.3)
" TODO session settings
" set sessionoptions=resize,winpos,winsize,buffers,tabpages,folds,curdir,help
set number                            " Show line numbers OR,...
"set relativenumber                    " Relative line numbers (>= Vim 7.3)
"set autocmdtowrite                         " Write the old file out when switching between files
"set mouse=a
"set mousehide                         " Hide mouse when typing
"set hidden                            " Switch between buffers without saving

filetype plugin indent on             " Enable filetype use
syntax enable                         " Turn on syntax highlighting allowing local overrides

" Source the vimrc file after saving it.
" This way, you don't have to reload Vim to see the changes.
if has("autocmdtocmd")
    autocmdgroup myvimrchooks
        autocmd!
        autocmdtocmd bufwritepost .vimrc source ~/.vimrc
    autocmdgroup END
endif

" No blinking cursor. See http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

" Saves file when Vim window loses focus
"autocmd FocusLost * :wa

" Ever notice a slight lag after typing the Leader key + command? This lowers
" the timeout.
"set timeoutlen=500

" Statusline setup
set statusline+=%=                    " Left/right separator
set statusline+=%c,                   " Cursor column
set statusline+=%l/%L                 " Cursor line/total lines
set statusline+=\ %P                  " Percent through file

""
"" Helpers
""

" View changes after the last save
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Some file types should wrap their text
function s:setupWrapping()
  set wrap
  set linebreak
  set textwidth=72
  set nolist
endfunction

" TODO: Delete this?
"function s:setupMarkup()
"  call s:setupWrapping()
"  map <buffer> <Leader>p :Hammer<CR>
"endfunction

" Alphabetically sort CSS properties in file with :SortCSS
":command! SortCSS :g#\({\n\)\@<=#.,/}/sort

" TODO: Check if this works.
function s:SortCSS()
  :g#\({\n\)\@<=#.,/}/sort
endfunction

" Remember last location in file
if has("autocmdtocmd")
    autocmdtocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \ exe "normal! g'\"" |
    \ endif
endif

" Removes trailing spaces
function RemoveTrailingSpaces()
  %s/\s*$//
  ''
endfunction

""
"" Mappings
""

" Set the Leader key
let mapLeader = ","

"Saves time; maps the spacebar to colon
nmap <space> :

"Map escape key to jj -- much faster
imap jj <esc>

"TODO: Map code completion to , + tab
"imap <Leader><tab> <C-x><C-o>

" Map F1 key to Esc.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" F2 toggles indenting when pasting
set pastetoggle=<F2>

" Set the keys to turn spell checking on/off
map <F8> <Esc>:setlocal spell spelllang=en_us<CR>
map <F9> <Esc>:setlocal nospell<CR>

" Map w!! to write file with sudo, when forgot to open with sudo.
cmap w!! w !sudo tee % >/dev/null

" Check changes from the last save
nnoremap <Leader>? :DiffSaved<CR>

"Hard-wrap paragraphs of text
nnoremap <Leader>q gqip

" No more stretching for navigating files
"noremap h ;
"noremap j h
"noremap k gj
"noremap l gk
"noremap ; l

" Easier window navigation
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Mapping to keep navigation based on display lines instead
" numbered lines
vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
nmap <D-0> g^

" Map the arrow keys to be based on display lines, not physical lines
map <Down> gj
map <Up> gk

" Shortcut for editing  vimrc file in a new tab
nmap <Leader>ev :tabedit $MYVIMRC<CR>

" Automatically change current directory to that of the file in the buffer
autocmd BufEnter * cd %:p:h

"Bubble single lines (kicks butt)
"http://vimcasts.org/episodes/bubbling-text/
nmap <C-Up> ddkP
nmap <C-Down> ddp

"Bubble multiple lines
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Opens the directory browser for the directory of the current path.
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Open the directory browser for the directory of the current path in a
" new tab.
" <Leader>te
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Insert the current directory into a command-line path
"cmap <C-P> <C-R>=expand("%:p:h") . "/"

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Get to home dir easier
" <Leader>hm is easier to type than :cd ~
nmap <Leader>hm :cd ~/ <CR>

"Opens a vertical split and switches over (\v)
"nnoremap <Leader>v <C-w>v<C-w>l

" TODO: Shortcut to opening a virtual split to right of current pane
" Makes more sense than opening to the left
"nnoremap <Leader>bv :bel vsp

"Delete all buffers (via Derek Wyatt)
nmap <silent> ,da :exec "1," . bufnr('$') . "bd"<CR>

""
"" Backups
""
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap// " swap files

""
"" Whitespace/tab stuff
""
set nowrap                                  " don't wrap lines
set autocmdtoindent
set tabstop=2                               " a tab is 2 (two) spaces
set shiftwidth=2                            " an autocmdtoindent (with <<) is two spaces
set softtabstop=2                           " two spaces when editing
set expandtab                               " use spaces, not tabs
set list listchars=tab:\ \ ,trail:·         " for tabs and trailing spaces
" set listchars=trail:⋅,nbsp:⋅,tab:▷⋅                 " for tabs and trailing spaces
set backspace=indent,eol,start              " allow backspacing over everything

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Remove highlighting search results
nnoremap <Leader><space> :nohlsearch <CR>

""
"" Tab completion and folding
""

"Enable code folding
set foldenable
"setlocal foldmethod=syntax            " folding uses syntax for folding
"setlocal nofoldenable                 " don't start with folded lines

"Shortcut to fold tags with Leader (usually \) + ft
nnoremap <Leader>ft Vatzf

" TODO Omnifunction/wildmode?
" set wildmenu
" set wildmode=longest:full,list:full

" set wildmode=list:longest,list:full as janus
" set wildmode=longest:full  as gavim2

" set wildmode=longest,list
" set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*
" setlocal ofu=syntaxcomplete#Complete  " enable syntax based omni completion

"http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
"set completeopt=longest,menuone
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
"\ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
"inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
"\ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

""
"" Filetype
""

" Don't write swapfile on most commonly used directories for NFS mounts or USB sticks
autocmd BufNewFile,BufReadPre /media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp

" Switch to working directory of the open file
autocmd BufEnter * lcd %:p:h

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" TODO: Delete?
" plain text
"autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
"
" md, markdown, and mk are markdown and define buffer-local preview
"autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

" Markdown and txt files should wrap
autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} call s:setupWrapping()

" make Python (and sh) follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
autocmd FileType python,sh set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

" make uses real tabs (not spaces)
autocmd FileType make set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
autocmd BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set filetype=ruby

" add json syntax highlighting
autocmd BufNewFile,BufRead *.json set ft=javascript

"Set up an HTML5 template for all new .html files
"autocmd BufNewFile * silent! 0r $VIMHOME/templates/%:e.tpl

""
"" Plugins
""

" NerdTREE
nnoremap <Leader>n :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
"let NERDTreeShowHidden=1

" NerdTREE - use colors, cursorline and return/enter key
let NERDChristmasTree = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeMapActivateNode='<CR>'

" NERDTree - Autopen and focus cursor in new document
"autocmd VimEnter * NERDTree
"autocmd VimEnter * wincmd p

" BufExplorer - easier invoke keys
nnoremap <Leader>bb :BufExplorer<cr>

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
map <C-\> :tnext<CR>

" Scratch - define invoke function
function! ToggleScratch()
  if expand('%') == g:ScratchBufferName
    quit
  else
    Sscratch
  endif
endfunction

" Scratch - keys to toggle Scratch buffer
map <Leader>s :call ToggleScratch()<CR>

" Unimpaired configuration
" Bubble single lines
"nmap <C-Up> [e
"nmap <C-Down> ]e

" Bubble multiple lines
"vmap <C-Up> [egv
"vmap <C-Down> ]egv

" Syntastic - enable syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" Fugitive (Git)
set statusline+=%{fugitive#statusline()}

" Gist-vim
if has("mac")
  let g:gist_clip_command = 'pbcopy'
elseif has("unix")
  let g:gist_clip_command = 'xclip -selection clipboard'
endif
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" Matchit - % to bounce from do to end etc.
runtime! macros/matchit.vim

" Vala - vala support
"autocmdtocmd BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
"autocmdtocmd BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
"autocmd BufRead,BufNewFile *.vala  setfiletype vala
"autocmd BufRead,BufNewFile *.vapi  setfiletype vala
"let vala_comment_strings = 1
"let vala_space_errors = 1
"let vala_no_tab_space_error = 1

" Ack - uncomment suitable line if configuration is necessary
"let g:ackprg="ack -H --nocolor --nogroup"         " if ack --version < 1.92
"let g:ackprg="ack-grep -H --nocolor --nogroup"    " for Debian/Ubuntu

" Conque - lautocmdnch terminal
nnoremap <Leader>t :ConqueTermSplit bash<CR>

" Snipmate configuration
source ~/.vim/snippets/support_functions.vim
autocmd vimenter * call ExtractSnips("~/.vim/snippets/html", "eruby")
autocmd vimenter * call ExtractSnips("~/.vim/snippets/html", "php")

" Rails - turn off rails related things in statusbar
"let g:rails_statusline=0

" RVM
set statusline+=%{exists('g:loaded_rvm')?rvm#statusline():''}

" LaTeX - configuration
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

" Turn off jslint errors by defautocmdlt
let g:JSLintHighlightErrorLine = 0

"Change zen coding plugin expansion key to shift + e
" TODO: Are we going to have zen coding or sparkup?
"let g:user_zen_expandabbr_key = '<C-e>'

" ZoomWin configuration
map <Leader><Leader> :ZoomWin<CR>

" Without setting this, ZoomWin restores windows in a way that cautocmdses
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" Command-T configuration
let g:CommandTMaxHeight=20

"Faster shortcut for commenting. Requires T-Comment plugin
" TODO this or nerdcommenter?
"map <Leader>c <c-_><c-_>

""
"" Colors and eye-candy
""

"Here's 100 to choose from: http://www.vim.org/scripts/script.php?script_id=625
colorscheme railscasts_alt
"colorscheme desert

""
"" Miscellaneous stuff
""

"Helpeful abbreviations
iab lorem Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
iab llorem Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

"Spelling corrects. Just for example. Add yours below.
iab teh the
iab Teh The

" Create dictionary for custom expansions
"set dictionary+=.vim/dict.txt

let macvim_hig_shift_movement = 1     " mvim shift-arrow-keys (required in vimrc)

"Hide MacVim toolbar by defautocmdlt
set go-=T

"Load the current buffer in Firefox - Mac specific.
abbrev ff :! open -a firefox.app %:p<cr>

"Map a change directory to the desktop - Mac specific
nnoremap <Leader>d :cd ~/Desktop<cr>:e.<cr>

""
"" Customizations
""
" Include user's local vim config
if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif
