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

vim.opt.diffopt = 'filler,internal,algorithm:histogram,indent-heuristic,followwrap'

if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1 -- enable use of the logo (cmd) key
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_input_use_logo = 1
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})

vim.cmd [[
  " remove ex mode
  map Q <Nop>
  map q: <Nop>
]]



vim.loader.enable()

-- Telescope keybindings
-- vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>Telescope find_files<cr>", { noremap = true, silent = true, desc = "Telescope - Find Files" })
-- vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true, desc = "Telescope - Live Grep" })
-- vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>Telescope buffers<cr>", { noremap = true, silent = true, desc = "Telescope - Buffers" })
-- vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>Telescope help_tags<cr>", { noremap = true, silent = true, desc = "Telescope - Help Tags" })
--
-- -- CopilotChat keybindings
-- vim.api.nvim_set_keymap('n', '<leader>cch', [[:lua require("CopilotChat.integrations.telescope").pick(require("CopilotChat.actions").help_actions())<cr>]], { noremap = true, silent = true, desc = "CopilotChat - Help actions" })
-- vim.api.nvim_set_keymap('n', '<leader>ccp', [[:lua require("CopilotChat.integrations.telescope").pick(require("CopilotChat.actions").prompt_actions())<cr>]], { noremap = true, silent = true, desc = "CopilotChat - Prompt actions" })
-- vim.api.nvim_set_keymap('n', '<leader>ccr', [[:lua require("CopilotChat.integrations.telescope").pick(require("CopilotChat.actions").response_actions())<cr>]], { noremap = true, silent = true, desc = "CopilotChat - Response actions" })
--

require("config.lazy")
