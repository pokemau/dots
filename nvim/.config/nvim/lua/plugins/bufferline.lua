return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',

    config = function()
      vim.opt.termguicolors = true
      require('bufferline').setup {

        options = {
          diagnostics = 'nvim_lsp',
          -- separator_style = 'slant',
          indicator = {
            --            style = 'underline',
          },
        },

        highlights = {
          buffer_selected = {
            bold = true,
            italic = false,
          },
          indicator_visible = {
            bg = '#000000',
            fg = '#000000',
          },
        },
      }

      vim.api.nvim_set_keymap('n', ']b', ':BufferLineMoveNext<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '[b', ':BufferLineMovePrev<CR>', { noremap = true, silent = true })
    end,
  },
}
