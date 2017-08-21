set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"
" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"
Plugin 'ctrlp.vim'
"
Plugin 'verilog_systemverilog.vim'

Plugin 'perl-support.vim'

Plugin 'upf.vim'

Bundle 'bash-support.vim'

" " All of your Plugins must be added before the following line
 call vundle#end()            " required
syntax enable

filetype plugin indent on    " required
"Color options
syntax on
set history=700
autocmd BufNewFile,BufRead *.sv,*.v,*.vh set filetype=verilog_systemverilog
autocmd BufRead,BufNewFile *.upf setfiletype upf
"gzip files
"autocmd BufRead *.gz call gzip#read("gzip -dn")
set t_Co=256
set showmode

set smartindent
set backspace=eol,start,indent
set autoread "auto updated the current buffer with the updated contents

" Spaces and tabs
set expandtab "tabs are NOT spaces
set tabstop=4 "number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4 " Auto indent amount when using >> or <<
set virtualedit=all "ability to walk through the empty area of the file in normal mode

"UI
set ruler " always show current position along the bottom
set number "turn on line numbers
set showcmd " show commandn in bottom bar
"filetype indent on      " load language -specific indent files:.vim/indent
set wildmenu            " visual autocomplete for command menu
set wildmode=list:longest
set showmatch           " highlight matching [{()}]
set cpoptions+=$ "put a dollar sign when using c command or r or s

" Text Formating/Layout
set ignorecase "case insensitive by default
set smartcase "If there are CAPS go-sensitive
set hlsearch  " highlight search terms
set incsearch " show search matches as you type
set nobackup
"set backupdir=~/vim/tmp/
set wrap
set laststatus=2

" Disable comment continuation on paste
"autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
"
" Focus follow mouse Use SHIFT for external copying
set mouse=a

" CUSTOM Mappings (the 'nor' in any mapping keyword means nonrecursive
" inorder to use <leader> before any mappings
:let mapleader = ","

" mappings, first letter tells in which mode.
xnoremap p "_dP
"This is help to paste the same thing second time.. so it
"replaces doing v"0p with only p

"mapping F2 key to toggle the paste option (only in normal mode)
vnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2> " This will toggle the paste mode. the noformat paste will only work when the paste mode is on
set showmode "This will show the paste mode or not

 "mapping F5 key to :e! in only normal mode(nnorremap) which will refresh the current log(below)
nnoremap <F5> :e!<CR>;

" mapping of ctrl-d to delete the current line in insert mode.
inoremap <c-d> <esc>ddi

"short cut to source the vimrc file (,sv)
:nnoremap <leader>sv :source $MYVIMRC<cr>

" shortcut to open the vimrc file
nnoremap <leader>ev :e $MYVIMRC<cr>

"toggle numbers-> nonumbers
nnoremap <leader>n :set invnumber<cr>

"Get the file name
nnoremap <leader>fname :echo @%<cr>
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/]\.(git|doc|svn)$'
            \}
let g:ctrlp_max_files = 0
let g:ctrlp_cmd = 'CtrlP'
noremap <leader>s :CtrlP<CR>
noremap <leader>v :CtrlP /$VC_WORKSPACE/<CR>
noremap <leader>b :CtrlPBuffer<CR>
noremap <leader>l : CtrlPLine<CR>
noremap <leader>m :CtrlPMixed<CR>
set shellslash

"let g:ctrlp_root_markers = ['.ctrlp']
"let g:ctrlp_follow_symlinks = 1
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'

let g:ctrlp_clear_cache_on_exit = 0
" open in background
let g:ctrlp_open_multiple_files = 'i'
let g:ctrlp_match_window = 'min:4,max:72:results:20'
if executable("ag")
    let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
endif
"if executable('grep')
"      let g:ctrlp_user_command = 'grep %s -l ""'
"endif
" set list listchars=trail:_
" set listchars=tab:·\ ,trail:·,extends:»,precedes:«
" :highlight SpecialKey ctermfg=darkgrey ctermbg=yellow
"
autocmd FileType make setlocal noexpandtab
" Remove extra spaces before saving
autocmd BufWritePre * %s/\s\+$//e

colorscheme mustang_vim_colorscheme_by_hcalves
"set background=dark
"
set cursorline          " highlight current line
hi CursorLine term=bold cterm=NONE guibg=darkred guifg=white



inoremap <Esc>Oq 1
inoremap <Esc>Or 2
inoremap <Esc>Os 3
inoremap <Esc>Ot 4
inoremap <Esc>Ou 5
inoremap <Esc>Ov 6
inoremap <Esc>Ow 7
inoremap <Esc>Ox 8
inoremap <Esc>Oy 9
inoremap <Esc>Op 0
inoremap <Esc>On .
inoremap <Esc>OQ /
inoremap <Esc>OR *
inoremap <Esc>Ol +
inoremap <Esc>OS -
inoremap <Esc>OM <Enter>


" " Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent        " always set autoindenting on

endif " has("autocmd")
" Undo after file write
if has('persistent_undo')      "check if your vim version supports it
    set undofile                 "turn on the feature
    set undodir=$HOME/.vim/undo  "directory where the undo files will be stored
endif

" Searching between module-endmodule in verilog (From ARNE)
nnoremap <F8> mc?module<CR>mb/endmodule<CR>me`c<BS>/\%>'b\%<'e
vnoremap <F8> y<Esc>mc?module<CR>mb/endmodule<CR>me`c<BS>/\%>'b\%<'e<C-r>0

"search for selected text (visual mode) (hint: v... works in both visual and select mode, use x for only visual mode...)
vnoremap / y<ESC>/<C-r>0
vnoremap ? y<ESC>?<C-r>0

"Ignore white space in vimdiff
set diffopt+=iwhite









