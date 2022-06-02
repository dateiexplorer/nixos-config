" ### General apperance 
set nocompatible " Disable compatibility to old-time vi

syntax on             " Enable syntax highlighting
set number            " Show line numbers
"set relativenumber   " Show line numbers relative to current line
set noshowmode        " Disable status bar (use lightline instead)
set scrolloff=5       " Cursor shouldn't be at the bottom
set mouse=a           " Allow scrolling with mouse
set lazyredraw        " Less redraws by macros and Co.
set updatetime=300    " Recommended for flawless drawing by updating UI
set laststatus=2      " Show always status (rec. setting by lightline)
set nowrap            " Don't wrap code by default
set linebreak         " Break whole words in new line

set cc=80,120         " Mark 80th colum for better coding

" ### Colors and schemes
colorscheme PaperColor " Color scheme text
set t_Co=256           " Enable 256 colors on the terminal

" ### Search
set path+=**          " Include subfolders in :find
set showmatch         " Show matching
set ignorecase        " Enable case insensitive search
set smartcase         " If capitals are incl. do a case sensitive search
set hlsearch          " Highlight search
set incsearch         " Enable incremental search

" ### Tabs & Spaces
set tabstop=4         " Tab intends 4 spaces
set softtabstop=4     " Set multiple spaces as tabstops
set expandtab         " Convert tabs to white space
set shiftwidth=4      " Width for autoindents
set autoindent        " Indent a new line the same amount as the previous
" Additional
filetype plugin indent on " Allow auto-indenting depending on file type

" Change beheviour for nix files
autocmd FileType nix setlocal tabstop=2 softtabstop=2 shiftwidth=2

" ### Language and spelling
set helplang=de       " Use german help

" Activate spell for mardown files
autocmd FileType mardkown setlocal spell
" Activate spell for general text files
autocmd FileType text setlocal spell

" ### Clipboard
set clipboard+=unnamedplus " Using system clipboard

" Shows a more advanced menu for auto-completion suggestions
set wildmenu

filetype plugin on

" ### NerdTree
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1

" Show NERDTree if no file opened
function! StartUp()
    if 0 == argc()
        NERDTree
        let g:nerdtree_open=1
    end
endfunction
"autocmd VimEnter * call StartUp()

" ### VimWiki
let g:vimwiki_list = [{'path': '$HOME/Sync/Wiki'}]

" ### Keybindings
let mapleader=" "

" Tabs
nnoremap <S-Tab> gT
nnoremap <Tab> gt

" Copy, cut and paste in system clibboard
" Maybe need some improvements here.
" Must install xclip (X11) or wl-copy, wl-paste (Wayland) to work.
vnoremap <C-c> "+y
vnoremap <C-x> "+c
nnoremap <C-v> "+p

" Toggle file tree
map <silent> <Leader>t :NERDTreeToggle<CR>

" Lightline support for theme changing (dark/light) on the fly
" Credits: https://github.com/itchyny/lightline.vim/issues/424
"autocmd OptionSet background
"    \ execute 'source' 
"    \ globpath(&rtp, 'autoload/lightline/colorscheme/PaperColor.vim')
"    \ | call lightline#colorscheme() | call lightline#update()


