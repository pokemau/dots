vim.pack.add({
  'https://github.com/johnfrankmorgan/whitespace.nvim'
})

vim.api.nvim_set_hl(0, 'TrailingSpaceRed', { bg = 'red' })

require('whitespace-nvim').setup({
  highlight = 'TrailingSpaceRed',
  ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'dashboard' },
  ignore_terminal = true,
  return_cursor = true,
})

vim.keymap.set('n', '<leader>t', require('whitespace-nvim').trim)
