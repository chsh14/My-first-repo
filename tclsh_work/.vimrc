set history=700



set t_Co=256
set showmode

set autoindent
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
filetype indent on      " load language -specific indent files:.vim/indent
set wildmenu            " visual autocomplete for command menu
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
nnoremap <F2> :set invpaste paste?<CR>
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
" set list listchars=trail:_
" set listchars=tab:·\ ,trail:·,extends:»,precedes:«
" :highlight SpecialKey ctermfg=darkgrey ctermbg=yellow
"
autocmd FileType make setlocal noexpandtab
" Remove extra spaces before saving
autocmd BufWritePre * %s/\s\+$//e
"Color options
syntax enable
colorscheme mustang_vim_colorscheme_by_hcalves
"set background=dark
"
set cursorline          " highlight current line
hi CursorLine term=bold cterm=bold guibg=Grey40
