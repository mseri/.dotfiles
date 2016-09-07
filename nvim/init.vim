" python support is needed for merlin
let g:python_host_prog = '/usr/bin/python'
" python3 support is needed for deoplete
let g:python3_host_prog = '/usr/bin/python3'

set nocompatible

filetype off
call plug#begin('~/.nvim/plugged')
Plug 'bling/vim-airline'
Plug 'NLKNguyen/papercolor-theme'
"Plug 'altercation/vim-colors-solarized'

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'benekastah/neomake'
Plug 'thirtythreeforty/lessspace.vim'

Plug 'klen/python-mode'
"Plug 'ElmCast/elm-vim'
"Plug 'phildawes/racer'
"Plug 'rust-lang/rust.vim'
"Plug 'leafgarland/typescript-vim'
"Plug 'elixir-lang/vim-elixir'
"Plug 'isRuslan/vim-es6'
Plug 'plasticboy/vim-markdown'
"Plug 'vim-ruby/vim-ruby'
Plug 'pangloss/vim-javascript'
"Plug 'cespare/vim-toml'
"Plug 'vim-scripts/freefem.vim'
Plug 'eagletmt/neco-ghc'
call plug#end()
filetype plugin indent on

set omnifunc=syntaxcomplete#Complete

"""""" OCaml Merlin (opam install merlin) """"""
let g:opamshare = substitute(system('opam config var share'), '\n$', '', '''')
execute 'set rtp+=' . g:opamshare . '/merlin/vim'
execute 'helptags ' . g:opamshare . '/merlin/vim/doc/'


"""""" OCaml ocp-indent and ocp-index (opam install ocp-index ocp-indent) """"""
execute 'autocmd FileType ocaml source' . g:opamshare . '/ocp-indent/vim/indent/ocaml.vim'
execute 'set rtp+=' . g:opamshare . 'ocp-index/vim'


"""""" Other OCaml specifics """"""
" \s : switches between the .ml and .mli file
" \c : comments the current line / selection (\C to uncomment)
" %  : jumps to matching let/in, if/then, etc (see :h matchit-install)
" \t : tells you the type of the thing under the cursor (if you compiled with -annot)
au BufRead,BufNewFile *.ml,*.mli compiler ocaml


"""""" Haskell autocomplete """"""
" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0

autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
autocmd FileType haskell setlocal nofoldenable
autocmd FileType haskell setlocal conceallevel=0
autocmd FileType haskell compiler hlint

nnoremap <leader>h= :execute "Tabularize haskell_bindings"<CR>
nnoremap <leader>ht :execute "GhcModType!"<CR>
nnoremap <leader>hT :execute "GhcModTypeInsert!"<CR>
nnoremap <leader>hc :execute "GhcModTypeClear"<CR>


"""""" Syntastic """"""
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
" (pip install pylint)
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_ocaml_checkers = ['merlin']
let g:syntastic_haskell_checkers = ['ghc_mod', 'hlint']

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
"set listchars="tab:>,trail:-,nbsp:+,eol:$"
set listchars+=trail:·,eol:↲,tab:→
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

let g:airline_theme='PaperColor'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Use ag instead of ack
let g:ackprg = 'ag --nogroup --nocolor --column'


"""""" rust racer """"""
set hidden
let g:racer_cmd = "/Users/marcelloseri/.cargo/bin/racer"


"""""" deoplete """"""
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
set completeopt=menuone,noinsert,noselect
" let g:deoplete#disable_auto_complete = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" ocaml fix for deoplete
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.ocaml = '[^ ,;\t\[()\]]'

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <C-c> <C-x><C-o>

"""""" neomake on <C-b> """"""
nnoremap <C-b> :w<cr>:Neomake<cr>

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
au FileType ocaml setl sw=2 sts=2 ts=2 tw=0 wrapmargin=0 expandtab
au FileType python setl sw=4 sts=4 ts=4 expandtab
au FileType ruby setl sw=4 sts=4 ts=4 expandtab
au FileType sh setl sw=4 sts=4 ts=4 expandtab
au FileType vim setl sw=4 sts=4 ts=4 expandtab
au FileType yaml setl sw=4 sts=4 ts=4 expandtab

" NERDTree bits.
nnoremap <C-l> :NERDTreeFind<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.swp$', '\.a$', '\.cmxa$', '\.o$', '\.spit$', '\.spot$', '\.cmi$', '\.cmx$', '\.annot$', "\.git$"]


