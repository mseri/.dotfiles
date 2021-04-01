set nocompatible

" install plug and the plugins if not yet installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

filetype off


call plug#begin('~/.cache/vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'thirtythreeforty/lessspace.vim'

"Plug 'klen/python-mode', { 'for': 'python' }

"Plug 'rust-lang/rust.vim', { 'for': 'rust' }

Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'luochen1990/rainbow'
"Plug 'rgrinberg/vim-ocaml'
Plug 'w0rp/ale'
"Plug g:ocamlocpindent, { 'for': 'ocaml' }
"Plug g:ocamlmerlin, { 'for': 'ocaml' }

Plug 'ajmwagar/vim-deus'

"Plug 'https://framagit.org/tyreunom/coquille.git', { 'for': 'coq' }
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'cespare/vim-toml'
call plug#end()

let g:rainbow_active = 0
let g:ale_lint_on_text_changed = 'never'
call ale#linter#Define('ocaml', { 'name': 'ocaml-lsp', 'lsp': 'stdio', 'executable': 'ocamllsp', 'command': '%e', 'project_root': function('ale#handlers#ols#GetProjectRoot') })

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
"set list
"set listchars=tab:→\ ,trail:·,eol:↲,nbsp:·
"highlight SpecialKey ctermfg=234 guifg=234
"highlight NonText ctermfg=234 guifg=234

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
"colorscheme Luna
"
colorscheme deus
let g:deus_termcolors=256

let g:airline_theme='deus'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Use ag instead of ack
let g:ackprg = 'ag --nogroup --nocolor --column'


""""""" Syntastic """"""
"let g:syntastic_enable_signs = 1
"let g:syntastic_error_symbol = '✗'
"let g:syntastic_warning_symbol = '⚠'
"let g:syntastic_python_checkers = ['pylint']
"let g:syntastic_ocaml_checkers = ['merlin']
"let g:syntastic_haskell_checkers = ['ghc_mod', 'hlint']


" NERDTree bits.
nnoremap <C-l> :NERDTreeFind<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.swp$', '\.a$', '\.cmxa$', '\.o$', '\.spit$', '\.spot$', '\.cmi$', '\.cmx$', '\.annot$', "\.git$"]

" fix for neovim/issues/#5990
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0

" show live search/replace
set inccommand=nosplit
