return {
  'ray-x/lsp_signature.nvim',
  event = 'InsertEnter',
  opts = {},
  config = function()
    require('lsp_signature').setup {
      hint_prefix = '',
      floating_window = false,
      bind = true,
    }
  end,
}
