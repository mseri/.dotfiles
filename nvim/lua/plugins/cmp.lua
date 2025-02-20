return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-omni',
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
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = true }),       },
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
