" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'christoomey/vim-tmux-navigator'
Plug 'moll/vim-bbye'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/a.vim'
Plug 'itchyny/lightline.vim'
Plug 'Valloric/YouCompleteMe', { 'for': ['python', 'c', 'cc', 'cpp'] }
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'fatih/vim-go'
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'tpope/vim-fugitive'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/FIGlet.vim'
Plug 'fadein/vim-FIGlet'
Plug 'w0rp/ale'
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go', { 'do': 'make'}
" color
"Plug 'iCyMind/NeoSolarized'
"Plug 'NLKNguyen/papercolor-theme'
"Plug 'jdkanani/vim-material-theme'
"Plug 'kristijanhusak/vim-hybrid-material'
"Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'zchee/deoplete-go', { 'do': 'make'}
"Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.vim/plugged/gocode/nvim/symlink.sh' }
"Plug 'mdempsky/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
"Plug 'chriskempson/base16-vim'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'rakr/vim-one'
"Plug 'morhetz/gruvbox'
"Plug 'shinchu/lightline-gruvbox.vim'
"Plug 'mhartington/oceanic-next'
" Initialize plugin system
call plug#end()

syntax enable

if exists("$ALACRITTY")
  set termguicolors
  "set background=light
  let g:nord_comment_brightness = 15
  colorscheme nord
else
  "set background=light
  "colorscheme PaperColor
  let g:nord_comment_brightness = 15
  colorscheme nord
endif


set number
set encoding=utf-8
let mapleader=","

" Copy and Paste {
  function! PasteFromTmp()
    let @" = readfile('/tmp/vitmp')[0]
  endfunc

vmap <leader>y y :call writefile([@"], '/tmp/vitmp')<CR>
nmap <leader>p :call PasteFromTmp()<CR>
" }

" Formatting {
  set nowrap                      " Do not wrap long lines
  set autoindent                  " Indent at the same level of the previous line
  set shiftwidth=4                " Use indents of 4 spaces
  set expandtab                   " Tabs are spaces, not tabs
  set tabstop=4                   " An indentation every four columns
  set softtabstop=4               " Let backspace delete indent
  set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
  set splitright                  " Puts new vsplit windows to the right of the current
  set splitbelow                  " Puts new split windows to the bottom of the current
  "set matchpairs+=<:>             " Match, to be used with %
  set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
  set laststatus=2
  autocmd Filetype go setlocal tabstop=4 shiftwidth=4 softtabstop=4
" }

" toggle NERDTree {
  map <C-y><C-t> :NERDTreeToggle<CR>
  " find dir where the current file is
  map <C-y><C-f> :NERDTreeFind<CR>
  vnoremap // y/<C-R><CR>
" }

set dictionary=/usr/share/dict/words

" Python Style {
  set smartcase
  set ff=unix
  set colorcolumn=80

  " highlight spurious whitespace before the linter does
  highlight ExtraWhitespace ctermbg='06' guibg='06'
  match ExtraWhitespace /\s\+$/

  " backups are a little silly when you're using patches constantly
  set nobackup
  set noswapfile

  map <F2> :mksession! ~/vim_session <cr> " Quick write session with F2
  map <F3> :source ~/vim_session <cr>     " And load session with F3
" }

" search {
" Press <F9> to toggle highlighting on/off, and show current value.
  set incsearch
  set hlsearch
  set lazyredraw
  noremap <F9> :set hlsearch! hlsearch?<CR>
" }

" === mappings ===
nmap G Gzz
nmap n nzz
nmap N Nzz

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" BBye {
  nnoremap <leader>q :Bdelete<CR>
" }

" Function Keys {
  nnoremap <F11> :set norelativenumber! norelativenumber?<CR>
  nnoremap <F10> :set spell! spell?<CR>
" }

" Cscope {
if has("cscope")
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    if filereadable("pycscope.out")
        cs add pycscope.out
    endif
    cs reset
endif
" }

" ctags {
  nnoremap <leader>] :ts <C-R>"<CR>
" }

" window {
  nnoremap <leader>m :res <bar> :vert res<CR>
" }

" open another current buffer instance {
  nnoremap <leader>" :let @"=@%<CR>
  nnoremap <leader>e :e <C-R>"<CR>
" }

" highlights {
  highlight SpellBad ctermfg='09' guifg='09'
" }

" checkttime {
  nnoremap <leader>c :checktime<CR>
" }

" fzf {
  nnoremap <C-p> :FZF<CR>
  command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
  nnoremap <C-s> :Rg<space>
  nnoremap <C-b> :Buffers<CR>
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
" }

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" file encoding {
set fileencodings=utf-8,gb2312
" }

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'modified'] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'relativepath', 'modified'] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ]]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" YouCompleteMe
  nnoremap <leader>jd :YcmCompleter GoTo<CR>
  nnoremap <leader>jc :YcmCompleter GoToDeclaration<CR>
  nnoremap <leader>je :YcmCompleter GetDoc<CR>

" terminal mode
  tnoremap <C-]> <C-\><C-n>
  tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  nnoremap <leader>t :8split +:terminal<CR>

" tabs
"  Make sure to use Option key as Meta key on Mac
  nnoremap <M-t> :tabnew<CR>
  nnoremap <M-w> :tabclose<CR>
  nnoremap <M-l> :tabnext<CR>
  nnoremap <M-h> :tabprev<CR>
"

" go

  let g:go_fmt_command = "goimports"
  let g:go_auto_type_info = 1

  " Enable deoplete on startup
  let g:deoplete#enable_at_startup = 1
  "let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
  filetype plugin on


" deoplete
inoremap <silent><expr> <TAB>
\ pumvisible() ? "\<C-n>" :
\ <SID>check_back_space() ? "\<TAB>" :
\ deoplete#mappings#manual_complete()

function! CloseAllUseless()
  windo if &buftype == "quickfix" || &buftype == "locationlist" | lclose | endif
endfunc
nmap <leader>u :call CloseAllUseless()<CR>
