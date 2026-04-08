" Minimal Vim Configuration with Sensible Defaults
" No plugins required

" ============================================================================
" vim-sensible defaults (manually included)
" ============================================================================

" Disable vi compatibility
set nocompatible

" Better backspace behavior
set backspace=indent,eol,start

" Search settings
set incsearch

" UI settings
set laststatus=2
set ruler
set wildmenu
set display=lastline

" File handling
set autoread
set history=1000

" Enable syntax and filetype
syntax on
filetype plugin indent on

" ============================================================================
" Additional sensible defaults
" ============================================================================

" Basic editing settings
set encoding=utf-8
set number
set showcmd

" Indentation
set expandtab
set tabstop=2
set shiftwidth=2
set shiftround

" No backup/swap files
set nobackup
set noswapfile
set nowritebackup

" Better split behavior
set splitbelow
set splitright

" ============================================================================
" Colorscheme
" ============================================================================

" Enable true colors if available
if has('termguicolors')
  set termguicolors
endif

colorscheme Tomorrow-Night
