set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'chriskempson/base16-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'easymotion/vim-easymotion'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'ervandew/supertab'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'wikitopian/hardmode'
Plugin 'tpope/vim-surround'
Plugin 'moll/vim-bbye'
"Plugin 'terryma/vim-expand-region'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'SirVer/ultisnips'

call vundle#end()            " required
filetype plugin indent on    " required<Paste>

set encoding=utf-8
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-default-dark
set background=dark
set guifont=Meslo_LG_M_for_Powerline:h10:cANSI:qDRAFT

set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='base16_default'

" common settings {
  syntax on
  set number
  set mouse=a
" }
let mapleader=","
" Copy and Paste {
  function PasteFromTmp()
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
" }

" toggle NERDTree
map <C-y><C-t> :NERDTreeToggle<CR>
" find dir where the current file is
map <C-y><C-f> :NERDTreeFind<CR>
vnoremap // y/<C-R>"<CR>

" let ctrp be faster {
  let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
  if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  endif
" }

set dictionary=/usr/share/dict/words

" vim-airline appears even with only one buffer
set laststatus=2

" Qumulo Style
" {
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


  function GetGooglePythonIndent(lnum)
    " Indent inside parens.
    " Align with the open paren unless it is at the end of the line.
    " E.g.
    "   open_paren_not_at_EOL(100,
    "                         (200,
    "                          300),
    "                         400)
    "   open_paren_at_EOL(
    "       100, 200, 300, 400)
    call cursor(a:lnum, 1)
    let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
  \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
  \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
  \ . " =~ '\\(Comment\\|String\\)$'")
    if par_line > 0
      call cursor(par_line, 1)
      if par_col != col("$") - 1
        return par_col
      endif
    endif
    " Delegate the rest to the original function.
    return GetPythonIndent(a:lnum)
  endfunction
" }

" ====== General Settings ======
" Press F4 to toggle highlighting on/off, and show current value.
set incsearch
noremap <F4> :set hlsearch! hlsearch?<CR>

" === mappings ===
nmap G Gzz
nmap n nzz
nmap N Nzz

"quick pairs
imap <leader>' ''<ESC>i
imap <leader>" ""<ESC>i
imap <leader>( ()<ESC>i
imap <leader>[ []<ESC>i

" =========== EasyMotion ===========
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap ss <Plug>(easymotion-overwin-f2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>w <Plug>(easymotion-w)
map <Leader>b <Plug>(easymotion-B)
map <Leader>e <Plug>(easymotion-e)

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap th  :bfirst<CR>
nnoremap tj  :bnext<CR>
nnoremap tk  :bprev<CR>
nnoremap tl  :blast<CR>

" BBye {
  nnoremap <leader>q :Bdelete<CR>
" }

" airline {
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
  nmap <leader>- <Plug>AirlineSelectPrevTab
  nmap <leader>+ <Plug>AirlineSelectNextTab
" }

" relative number {
  function! NumberToggle()
    if(&relativenumber == 1)
      set norelativenumber
    else
      set relativenumber
    endif
  endfunc

  nnoremap <F11> :call NumberToggle()<CR>
" }

" Spell {
  function! SpellToggle()
    if(&spell == 0)
      set spell
    else
      set nospell
    endif
  endfunc
  nnoremap <F10> :call SpellToggle()<CR>
" }
