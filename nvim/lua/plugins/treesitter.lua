return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function ()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
      ensure_installed = "all",
      highlight = {
        enable = true,
        disable = { "latex" },
      },
      indent = {
        enable = true,
        disable = { "latex" },
      },
      incremental_selection = {
        enable = true,
        disable = { "latex" },
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      }
    })
  end
}
