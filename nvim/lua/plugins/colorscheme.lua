return {
  {
    'sainnhe/sonokai',
    config = function (_)
      vim.g['sonokai_style'] = "atlantis"
      vim.cmd [[colorscheme sonokai]]
    end
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("lualine").setup()
    end,
  },

  -- Which-key
  {
    'folke/which-key.nvim',
    lazy = true,
  },
}
