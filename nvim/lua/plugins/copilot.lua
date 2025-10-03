return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        filetypes = {
          markdown = true,
          sh = function ()
            if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '.*rc')
              or string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '.*env.*')
            then
              -- disable for *rc or *env files
              return false
            end
            return true
          end,
        },
        suggestion = {
          auto_trigger = true,
        },
      })
    end,  
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or 
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
  },
}
