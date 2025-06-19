return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    opts = {

    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)

      vim.keymap.set('n', '<leader>c', ':CopilotChat<CR>', { noremap = true, silent = true })
    end,
  },
}
