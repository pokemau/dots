return {
  'nvim-neo-tree/neo-tree.nvim',
  -- branch = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      window = {
        mappings = {
          ['s'] = 'set_root'
        }
      }
    }
    vim.keymap.set('n', '<leader>e', ':Neotree toggle reveal<CR>', { noremap = true, silent = true })
  end,
}
