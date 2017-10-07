" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'VundleVim/Vundle.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'christoomey/vim-tmux-navigator'
Plug 'moll/vim-bbye'
"Plug 'vim-scripts/vcscommand.vim'
"Plug 'gabrielelana/vim-markdown'
Plug 'neomake/neomake'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/a.vim'
Plug 'ervandew/supertab'

" Initialize plugin system
call plug#end()

set encoding=utf-8
let base16colorspace=256   " Access colors present in 256 colorspace
colorscheme base16-tomorrow-night
set background=dark
set guifont=Meslo_LG_M_for_Powerline:h10:cANSI:qDRAFT
let mapleader=","

" airline {
  let g:airline_powerline_fonts = 1
  "let g:airline_theme='base16_'
  let g:airline#extensions#neomake#enabled = 1
" }

" common settings {
  syntax on
  set number
  set mouse=a
" }
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

" toggle NERDTree {
  map <C-y><C-t> :NERDTreeToggle<CR>
  " find dir where the current file is
  map <C-y><C-f> :NERDTreeFind<CR>
  vnoremap // y/<C-R><CR>
" }

" ctrl-p {
  set runtimepath^=~/.vim/bundle/ctrlp.vim
  let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_lazy_update = 20
  if executable('rg')
    set grepprg=rg\ --color=never
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  endif
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

  let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
" }

set dictionary=/usr/share/dict/words

" vim-airline appears even with only one buffer
set laststatus=2

" Qumulo Python Style {
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

" relative number {
  nnoremap <F11> :set norelativenumber! norelativenumber?<CR>
" }

" Spell {
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

" ack {
  if executable('rg')
    let g:ackprg = 'rg --column -C 2'
    let g:ackhighlight = 1
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

" build {
  "set makeprg=build
  "nnoremap <leader>b :Neomake!<CR>
"

" lint {
  function! BuildSuccess(entry)
    if a:entry.text == "build: success!"
      echo "Build Success!"
    endif
  endfunction
  let g:neomake_c_lint_maker = {
    \ 'exe': 'build',
    \ 'args': ['%:h'],
    \ 'errorformat': '%f:%l:%c: %m',
    \ 'postprocess': function('BuildSuccess'),
    \ }
  let g:neomake_cpp_lint_maker = {
    \ 'exe': 'build',
    \ 'args': ['%:h'],
    \ 'errorformat': '%f:%l:%c: %m',
    \ 'postprocess': function('BuildSuccess'),
    \ }
  "autocmd BufWritePost ~/src/*.c Neomake lint
  "autocmd BufWritePost ~/src/*.h Neomake lint
  let g:neomake_open_list = 2
  nnoremap <leader>b :Neomake lint<CR>
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
" }

" file encoding {
set fileencodings=utf-8,gb2312
" }
