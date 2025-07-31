let mapleader = " "

set autowrite
set backspace=2
set colorcolumn=+1
set encoding=utf-8
set expandtab
set history=50
set incsearch
set laststatus=2
set list listchars=tab:»·,trail:·,nbsp:·
set modelines=0
set nobackup
set nojoinspaces
set nomodeline
set noswapfile
set nowritebackup
set number
set numberwidth=5
set ruler
set shiftround
set shiftwidth=2
set showcmd
set tabstop=2
set textwidth=80
set termguicolors
set spellfile=$HOME/.vim-spell-en.utf-8.add
set complete+=kspell
set diffopt+=vertical
set clipboard=exclude:.*
set modelines=1
set modeline
set nowrap
set nofoldenable

syntax on

let g:is_posix = 1

if &compatible
  set nocompatible
end

" Remove declared plugins
function! s:UnPlug(plug_name)
  if has_key(g:plugs, a:plug_name)
    call remove(g:plugs, a:plug_name)
  endif
endfunction

command!  -nargs=1 UnPlug call s:UnPlug(<args>)

call plug#begin('~/.vim/bundle')

Plug 'adelarsq/vim-matchit'
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dense-analysis/ale'
Plug 'ghifarit53/tokyonight-vim'
Plug 'github/copilot.vim'
Plug 'godlygeek/tabular'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'pangloss/vim-javascript'
Plug 'pbrisbin/vim-mkdir'
Plug 'preservim/vim-markdown'
Plug 'rhysd/conflict-marker.vim'
Plug 'rust-lang/rust.vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

call plug#end()

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile *.js set filetype=javascript
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile
    \ aliases.local,
    \zshenv.local,zlogin.local,zlogout.local,zshrc.local,zprofile.local,
    \*/zsh/configs/*
    \ set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead,BufNewFile vimrc.local set filetype=vim
augroup END

" wildmode will allow you to use tab completion in a more intuitive way
set wildmode=list:longest,list:full
set completeopt=menu,menuone,preview,noselect,noinsert

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Set tags for vim-fugitive
set tags^=.git/tags

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

let g:netrw_banner = 0

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

set statusline+=%#warningmsg#
set statusline+=%{LinterStatus()}
set statusline+=%*


" Enable syntax highlighting in markdown code blocks
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'javascript', 'typescript', 'rust', 'go', 'java', 'cpp', 'c', 'css', 'sql', 'yaml', 'json']
autocmd FileType cpp setlocal nowrap nolinebreak tabstop=2 shiftwidth=2 textwidth=0 expandtab list nofoldenable number
autocmd FileType html setlocal nospell nowrap nolinebreak tabstop=2 shiftwidth=2 textwidth=0 expandtab list nofoldenable number
autocmd FileType markdown setlocal spell wrap linebreak tabstop=4 shiftwidth=4 textwidth=0 expandtab nolist nofoldenable nonumber
autocmd FileType ruby setlocal nospell nowrap nolinebreak tabstop=2 shiftwidth=2 textwidth=0 expandtab list nofoldenable number
autocmd FileType rust setlocal nowrap nolinebreak tabstop=4 shiftwidth=4 textwidth=0 expandtab nolist foldenable number
autocmd FileType swift setlocal nowrap nolinebreak tabstop=4 shiftwidth=4 textwidth=0 expandtab nolist foldenable number
autocmd FileType toml setlocal nowrap nolinebreak tabstop=4 shiftwidth=4 textwidth=0 expandtab nolist foldenable number
autocmd FileType vim setlocal nowrap nolinebreak tabstop=2 shiftwidth=2 textwidth=0 expandtab list nofoldenable number
autocmd FileType yaml setlocal nowrap nolinebreak tabstop=2 shiftwidth=2 textwidth=0 expandtab nolist foldenable number

" configure rust
let g:rustfmt_autosave = 1

" ControlP
if executable('fd')
    let g:ctrlp_user_command = 'fd --type file --follow --hidden --exclude .git'
    let g:ctrlp_use_caching = 0
endif

" Grep
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
    set grepformat=%f:%l:%c:%m,%f:%l:%m
    let g:ackprg='rg --vimgrep --no-heading --smart-case'
endif


let js_fixers = ['prettier', 'eslint']
let g:ale_sign_error = ''
let g:ale_sign_warning = '󰈅'
let g:ale_fix_on_save = 1
let g:ale_fixers = {
  \ '*': ['trim_whitespace', 'remove_trailing_lines'],
  \ 'rust': ['rustfmt'],
  \ 'typescript': js_fixers,
  \ 'javascript': js_fixers,
  \ 'javascript.jsx': js_fixers,
  \ 'json': ['prettier'],
  \ 'css': ['prettier'],
  \}

let g:ale_linters = {
  \ 'rust': ['analyzer'],
  \ 'typescript': ['deno'],
  \ 'javascript': ['deno'],
  \ 'json': ['prettier'],
  \ 'css': ['prettier'],
  \}

set noshowmode
let g:lightline = {
      \ 'colorscheme': 'tokyonight',
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \   },
      \   'component_function': {
      \     'gitbranch': 'FugitiveHead'
      \   },
      \ }
let g:copilot_filetypes = {
\ '*': v:false,
\ 'rust': v:true,
\ 'markdown': v:true,
\ 'vim': v:true,
\ 'ts': v:true,
\ 'js': v:true,
\ }

:nnoremap <leader>ais :Copilot panel<CR>
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>rv :source $MYVIMRC<cr>

let g:tokyonight_style = 'night'
let g:tokyonight_enable_italic = 1
let g:tokyonight_transparent_background = 0
colorscheme tokyonight
