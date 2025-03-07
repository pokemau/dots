return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',

    config = function()
      vim.opt.termguicolors = true
      require('bufferline').setup {

        highlights = {
          buffer_selected = {
            bold = true,
            italic = false,
          },
        },
      }
    end,
  },
}
