vim.g.python3_host_prog = '/opt/local/bin/python3'

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = 'a'
vim.opt.updatetime = 100
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.completeopt = {'menuone', 'noselect'}
vim.opt.hidden = true
vim.opt.clipboard = {'unnamedplus'}
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.inccommand = 'nosplit'
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.laststatus = 2
-- vim.opt.list = true
-- vim.opt.listchars = {
--  tab = '→',
--  extends = '»',
--  precedes = '«',
--  trail = '·'
--  --,
--  -- eol = '↲',
--  -- nbsp = '·'
--  }
vim.opt.number = true
vim.opt.relativenumber = false 
vim.opt.cursorline = true
vim.opt.showcmd = true
vim.opt.lazyredraw = true
vim.opt.termguicolors = true

vim.opt.diffopt = 'filler,internal,algorithm:histogram,indent-heuristic'

require('plugins')

vim.cmd [[

function! s:write_server_name() abort
  let nvim_server_file = (has('win32') ? $TEMP : '/tmp') . '/vimtexserver.txt'
  call writefile([v:servername], nvim_server_file)
endfunction

augroup vimtex_common
  autocmd!
  autocmd FileType tex call s:write_server_name()
augroup END

"let g:vimtex_view_method = 'skim'
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

" remove ex mode
map Q <Nop>
map q: <Nop>
]]
-- function! UpdateSkim() abort
--   let l:out = b:vimtex.out()
--   let l:src_file_path = expand('%:p')
--   let l:cmd = [g:vimtex_view_general_viewer, '-r']
-- 
--   if !empty(system('pgrep Skim'))
--     call extend(l:cmd, ['-g'])
--   endif
-- 
--   call jobstart(l:cmd + [line('.'), l:out, l:src_file_path])
-- endfunction
-- 
-- augroup vimtex_mac
--   autocmd!
--   autocmd User VimtexEventCompileSuccess call UpdateSkim()
-- augroup END


