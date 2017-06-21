" python support is needed for merlin
let g:python_host_prog = '/usr/bin/python'
" python3 support is needed for deoplete
let g:python3_host_prog = '/usr/bin/python3'

set nocompatible

" install plug and the plugins if not yet installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

filetype off

if executable("opam")
  let g:opamshare = substitute(system('opam config var share'),'\n$','','''')

  let g:ocamlocpindent = g:opamshare . "/ocp-indent/vim"
  if !isdirectory(g:ocamlocpindent)
    echom "Couldn't find ocp-indent in " . g:ocamlocpindent
    let g:ocaml_has_ocpindent = 0
  else
    let g:ocaml_has_ocpindent = 1
  endif

  let g:ocamlmerlin =  g:opamshare . "/merlin/vim"
  if !isdirectory(g:ocamlmerlin)
    echom "Couldn't find merlin in " . g:ocamlmerlin
    let g:ocaml_has_merlin = 0
  else
    let g:ocaml_has_merlin = 1
  endif
endif

call plug#begin('~/.cache/vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'thirtythreeforty/lessspace.vim'

Plug 'klen/python-mode'

Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'luochen1990/rainbow'
Plug 'rgrinberg/vim-ocaml'
Plug 'w0rp/ale'
Plug g:ocamlocpindent, { 'for': 'ocaml' }
Plug g:ocamlmerlin, { 'for': 'ocaml' }

call plug#end()

function FT_ocaml()
    setlocal textwidth=80
    setlocal colorcolumn=80
    setlocal shiftwidth=2
    setlocal tabstop=2
    setlocal expandtab
    setlocal smarttab

    if g:ocaml_has_merlin
      nmap <LocalLeader>d :MerlinDocument<CR>
      nmap <LocalLeader>gd :MerlinILocate<CR>
      nmap <LocalLeader>m :MerlinDestruct<CR>
      nmap <LocalLeader>o :MerlinOutline<CR>
      nmap <LocalLeader>r <Plug>(MerlinRename)
      nmap <LocalLeader>R <Plug>(MerlinRenameAppend)
      nmap <LocalLeader>T :MerlinYankLatestType<CR>
    endif

    vmap a- :Tabularize /-><CR>
    vmap a: :Tabularize /:<CR>

    " Load topkg in Merlin when editing pkg/pkg.ml
    if expand("%:p") =~# "pkg\/pkg\.ml$"
      call merlin#Use("topkg")
    endif

    call SuperTabSetDefaultCompletionType("<c-x><c-o>")
endfunction

au FileType ocaml call FT_ocaml()
au BufRead,BufNewFile *.ml,*.mli compiler ocaml

autocmd BufNewFile,BufRead jbuild setlocal filetype=scheme
autocmd BufNewFile,BufRead jbuild :RainbowToggle

let g:rainbow_active = 0
let g:ale_lint_on_text_changed = 'never'

filetype plugin indent on

"""""" Aesthetic """"""
" Enable use of 256 colours (see
" https://github.com/guns/xterm-color-table.vim)
set t_Co=256
" Enable syntax colouring
syntax on
" Always show status bar
set laststatus=2
" Let plugins show effects after 500ms, not 4s
set updatetime=500
" Highlight cursor line
set cursorline
" Show line numbers
"set number

" highlight tabs spaces and newlines
set list
set listchars=tab:→\ ,trail:·,eol:↲,nbsp:·
highlight SpecialKey ctermfg=234 guifg=234
highlight NonText ctermfg=234 guifg=234

" hint to keep lines short
" highlight the 80th column, and the space after the 100th one
" using a very dark grey color
execute "set colorcolumn=81," . join(range(101,500),',')
highlight ColorColumn ctermbg=233 guibg=233

" Use spaces for tabs, <C-V><Tab> to actually instert a tab
set autoindent
set smartindent
set cindent
set tabstop=2 shiftwidth=4 softtabstop=0
"set expandtab
set expandtab


""""""" Keybindings """""""
" Set up leaders
let mapleader=","
let maplocalleader="\\"

" paste fix for osx
nnoremap <F2> :set invpaste paste?<cr>
set pastetoggle=<F2>

" change indent in visual mode
vnoremap < <gv
vnoremap > >gv

" clear search highlights
noremap <leader><space> :noh<CR>


"""""" Theme """"""
"let g:airline_solarized_bg="dark"
"color solarized

set background=dark
"colorscheme PaperColor

let g:airline_theme='papercolor'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Use ag instead of ack
let g:ackprg = 'ag --nogroup --nocolor --column'


""""""" Syntastic """"""
"let g:syntastic_enable_signs = 1
"let g:syntastic_error_symbol = '✗'
"let g:syntastic_warning_symbol = '⚠'
"" (pip install pylint)
"let g:syntastic_python_checkers = ['pylint']
"let g:syntastic_ocaml_checkers = ['merlin']
"let g:syntastic_haskell_checkers = ['ghc_mod', 'hlint']


""""""" rust racer """"""
"set hidden
"let g:racer_cmd = "/Users/marcelloseri/.cargo/bin/racer"


" Filetype detection.
" au BufRead,BufNewFile *xensource.log* set filetype=messages
au BufRead {*xensource.log*,*.log,messages*} setl ft=messages

" Filetype-specific settings.
au FileType c setl sw=4 sts=4 ts=4 expandtab
au FileType cmake setl sw=4 sts=4 ts=4 expandtab
au FileType cpp setl sw=4 sts=4 ts=4 expandtab
au FileType css setl sw=4 sts=4 ts=4 expandtab
au FileType cucumber setl sw=4 sts=4 ts=4 expandtab
au FileType erlang setl sw=4 sts=4 ts=4 expandtab
au FileType haskell setl sw=4 sts=4 ts=4 expandtab
au FileType html setl sw=4 sts=4 ts=4 expandtab
au FileType javascript setl sw=4 sts=4 ts=4 tw=0 wrapmargin=0 expandtab
" OCaml is set above to ocp-indent
"au FileType ocaml setl sw=2 sts=2 ts=2 tw=0 wrapmargin=0 expandtab
au FileType python setl sw=4 sts=4 ts=4 expandtab
au FileType ruby setl sw=4 sts=4 ts=4 expandtab
au FileType sh setl sw=4 sts=4 ts=4 expandtab
au FileType vim setl sw=4 sts=4 ts=4 expandtab
au FileType yaml setl sw=4 sts=4 ts=4 expandtab

" NERDTree bits.
nnoremap <C-l> :NERDTreeFind<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.swp$', '\.a$', '\.cmxa$', '\.o$', '\.spit$', '\.spot$', '\.cmi$', '\.cmx$', '\.annot$', "\.git$"]

" fix for neovim/issues/#5990
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0

