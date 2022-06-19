vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use{'lewis6991/impatient.nvim', config = [[require('impatient')]]}

  -- manage packer using packer.nvim
  use 'wbthomason/packer.nvim'

  -- use {
  -- 'arcticicestudio/nord-vim',
  --  config = function ()
  --    vim.o.background = 'dark'
  --    vim.cmd [[colorscheme nord]]
  --  end
  -- }

  use {
    'sainnhe/sonokai',
    config = function ()
      vim.g['sonokai_style'] = "atlantis"
      vim.cmd [[colorscheme sonokai]]
    end
  }

  use {
    'famiu/feline.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons'
    },
    config = function ()
      require('feline').setup({ 
        preset='noicon'
      }) 
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
    requires = {
      'romgrk/nvim-treesitter-context'
    },
    config = function ()
      require('nvim-treesitter.configs').setup {
        ensure_installed = "all",
        highlight = {
          enable = true,
          disable = { "latex" },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        }
      }

      require('treesitter-context').setup {
        enable = true
      }
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function ()
      require('gitsigns').setup()
    end
  }

  use "lukas-reineke/indent-blankline.nvim"

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-omni'
    },
    config = function()
      local cmp = require 'cmp'

      cmp.setup {
        mapping = {
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, 
          ['<ESC>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
        completion = {
          keyword_length = 1,
          completeopt = "menu,noselect"
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'omni' }
        }
      }
    end
  }

  use {
    'neovim/nvim-lspconfig',
    after = "cmp-nvim-lsp",
    config = function()
      local nvim_lsp = require('lspconfig')

      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.preselectSupport = true
      capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
      capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
      capabilities.textDocument.completion.completionItem.deprecatedSupport = true
      capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
      capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        }
      }

      local servers = { 'ocamllsp' }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          on_attach = on_attach,
          capabilities = capabilities,
          flags = {
            debounce_text_changes = 500,
          }
        }
      end
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  }

  use {
    "terrortylor/nvim-comment",
    config = function ()
      require('nvim_comment').setup({
        line_mapping = "<leader>cl",
        operator_mapping = "<leader>c"
      })
    end
  }

  use 'lervag/vimtex'

end)
