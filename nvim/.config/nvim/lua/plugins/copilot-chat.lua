return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    opts = {
      model = 'claude-sonnet-4',
    },
    config = function(_, opts)
      require('CopilotChat').setup(opts)

      vim.keymap.set('n', '<leader>c', ':CopilotChat<CR>', { noremap = true, silent = true })
    end,
  },
}
