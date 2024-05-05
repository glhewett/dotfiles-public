set encoding=utf-8

" Leader
let mapleader = " "

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set modelines=0   " Disable modelines as a security precaution
set nomodeline

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif


" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

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

" ALE linting events
augroup ale
  autocmd!

  if g:has_async
    autocmd VimEnter *
      \ set updatetime=1000 |
      \ let g:ale_lint_on_text_changed = 0
    autocmd CursorHold * call ale#Queue(0)
    autocmd CursorHoldI * call ale#Queue(0)
    autocmd InsertEnter * call ale#Queue(0)
    autocmd InsertLeave * call ale#Queue(0)
  else
    echoerr "The thoughtbot dotfiles require NeoVim or Vim 8"
  endif
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-p>"
    endif
endfunction
" inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
" inoremap <S-Tab> <C-n>

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <Leader>gt :TestVisit<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<Space>

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

" Map Ctrl + p to open fuzzy find (FZF)
" nnoremap <c-p> :Files<cr>

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" do not connect to x server
set clipboard=exclude:.*

set modelines=1
set modeline
set nowrap
set nofoldenable

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

let g:netrw_banner = 0

command! -nargs=* Wrap set wrap linebreak nolist tw=0

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction

nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
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

" configure lightline
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \   },
      \   'component_function': {
      \     'gitbranch': 'FugitiveHead'
      \   },
      \ }
" end configure lightline

autocmd FileType markdown setlocal spell wrap linebreak tabstop=4 shiftwidth=4 textwidth=0 expandtab nolist nofoldenable nonumber
autocmd FileType ruby setlocal nospell nowrap nolinebreak tabstop=2 shiftwidth=2 textwidth=0 expandtab list nofoldenable number
autocmd FileType html setlocal nospell nowrap nolinebreak tabstop=2 shiftwidth=2 textwidth=0 expandtab list nofoldenable number
autocmd FileType swift setlocal nowrap nolinebreak tabstop=4 shiftwidth=4 textwidth=0 expandtab nolist foldenable number
autocmd FileType yaml setlocal nowrap nolinebreak tabstop=2 shiftwidth=2 textwidth=0 expandtab nolist foldenable number
autocmd FileType rust setlocal nowrap nolinebreak tabstop=4 shiftwidth=4 textwidth=0 expandtab nolist foldenable number
autocmd FileType toml setlocal nowrap nolinebreak tabstop=4 shiftwidth=4 textwidth=0 expandtab nolist foldenable number
autocmd FileType cpp setlocal nowrap nolinebreak tabstop=2 shiftwidth=2 textwidth=0 expandtab list nofoldenable number
autocmd FileType vim setlocal nowrap nolinebreak tabstop=2 shiftwidth=2 textwidth=0 expandtab list nofoldenable number

" configure rust
let g:rustfmt_autosave = 1

" configure cpp
autocmd BufNewFile .projections.json 0r ~/.skeletons/projections.json
autocmd BufNewFile CMakeLists.txt 0r ~/.skeletons/CMakeLists.txt
autocmd BufNewFile *.cpp 0r ~/.skeletons/cpp.cpp
autocmd BufNewFile *.hpp 0r ~/.skeletons/cpp.hpp
" end configure cpp

" configure vim format
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>rv :source $MYVIMRC<cr>
" end configure vim format

" configure colors
colorscheme Tomorrow-Night
" end configure colors

set tags=./tags;/

" reformatting code
function! Format() abort
    :echo "hello, world!"
endfunction
nnoremap <silent> <Leader>f :call Format()<CR>
command Format :call Format()<CR>

" Codeium
"let g:codeium_disable_bindings = 1
"let g:codeium_manual = v:true
" imap <script><silent><nowait><expr> <C-g> codeium#Accept()
" imap <C-;>   <Cmd>call codeium#CycleCompletions(1)<CR>
" imap <C-,>   <Cmd>call codeium#CycleCompletions(-1)<CR>
" imap <C-x>   <Cmd>call codeium#Clear()<CR>

" Copilot

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

" Local config
if filereadable($HOME . "/.vimrc.private")
  source ~/.vimrc.private
endif

if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
