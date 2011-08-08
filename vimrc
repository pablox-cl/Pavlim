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
set modelines=10
set viminfo='20,\"50                  " Use a viminfo file,...
set history=50                        " Limit history
set ruler                             " Show the cursor position
set title                             " Show title
set t_Co=256                          " Uses 256 colors
set laststatus=2                      " Always show status bar
set showcmd                           " Show command in bottom right portion of the screen
set linespace=3                       " Prefer a slightly higher line height
set showmatch                         " Show matching brackets
" TODO session settings  
" set sessionoptions=resize,winpos,winsize,buffers,tabpages,folds,curdir,help  
set number                            " Show line numbers OR,...
"set relativenumber                    " Relative line numbers (>= Vim 7.3)
"set autowrite                         " Write the old file out when switching between files
"set mouse=a
"set mousehide                         " Hide mouse when typing  

filetype plugin indent on             " Enable filetype use
syntax enable                         " Turn on syntax highlighting allowing local overrides

" Source the vimrc file after saving it.
" This way, you don't have to reload Vim to see the changes.  
if has("autocmd")  
    augroup myvimrchooks  
        au!  
        autocmd bufwritepost .vimrc source ~/.vimrc  
    augroup END  
endif  

" No blinking cursor. See http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

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

""
"" Mappings
""

" Set the leader key
let mapleader = ","

"Saves time; maps the spacebar to colon  
nmap <space> :  

"Map escape key to jj -- much faster  
imap jj <esc>  

"TODO: Map code completion to , + tab  
"imap <leader><tab> <C-x><C-o> 

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
nnoremap <leader>? :DiffSaved<cr>

" Easier window navigation  
nmap <C-h> <C-w>h  
nmap <C-j> <C-w>j  
nmap <C-k> <C-w>k  
nmap <C-l> <C-w>l  

" Shortcut for editing  vimrc file in a new tab  
nmap <leader>ev :tabedit $MYVIMRC<cr>  

" Automatically change current directory to that of the file in the buffer  
autocmd BufEnter * cd %:p:h  

"Bubble single lines (kicks butt)  
"http://vimcasts.org/episodes/bubbling-text/
nmap <C-Up> ddkP 
nmap <C-Down> ddp

"Bubble multiple lines  
vmap <C-Up> xkP`[V`]  
vmap <C-Down> xp`[V`] 

""
"" Backups
""
set backupdir=~/.vim/tmp/backup// " backups  
set directory=~/.vim/tmp/swap// " swap files  

""
"" Whitespace/tab stuff
""
set nowrap                                  " don't wrap lines
set autoindent
set tabstop=2                               " a tab is 2 (two) spaces
set shiftwidth=2                            " an autoindent (with <<) is two spaces
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
nnoremap <leader><space> :nohlsearch <CR>

" Tab completion
" TODO Omnifunction/wildmode?
" set wildmenu 
" set wildmode=list:longest,list:full
" set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*
" setlocal ofu=syntaxcomplete#Complete  " enable syntax based omni completion
" setlocal foldmethod=syntax            " folding uses syntax for folding
" setlocal nofoldenable                 " don't start with folded lines

" Remember last location in file
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \ exe "normal! g'\"" |
    \ endif
endif    

""
"" Filetype
""

" Don't write swapfile on most commonly used directories for NFS mounts or USB sticks
autocmd BufNewFile,BufReadPre /media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp

" Switch to working directory of the open file
au BufEnter * lcd %:p:h

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
"au BufRead,BufNewFile *.txt call s:setupWrapping()
"
" md, markdown, and mk are markdown and define buffer-local preview
"au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

" Markdown and txt files should wrap
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} call s:setupWrapping()

" make Python (and sh) follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python,sh set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

" make uses real tabs (not spaces)
au FileType make set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set filetype=ruby

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

"Set up an HTML5 template for all new .html files  
"autocmd BufNewFile * silent! 0r $VIMHOME/templates/%:e.tpl  

""
"" Plugins
""
"" TODO

""
"" Colors and eye-candy
""

"Here's 100 to choose from: http://www.vim.org/scripts/script.php?script_id=625  

colorscheme railscasts_alt

""
"" Miscellaneous stuff
""

"Helpeful abbreviations  
iab lorem Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.  
iab llorem Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.   

"Spelling corrects. Just for example. Add yours below.  
iab teh the
iab Teh The

let macvim_hig_shift_movement = 1     " mvim shift-arrow-keys (required in vimrc)

"Hide MacVim toolbar by default  
set go-=T

""
"" Customizations
""

if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif
