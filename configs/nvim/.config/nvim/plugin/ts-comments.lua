vim.pack.add({
  'https://github.com/folke/ts-comments.nvim'
})

vim.treesitter.language.register('tsx', 'typescriptreact')
vim.treesitter.language.register('javascript', 'javascriptreact')

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

require('ts-comments').setup({})
