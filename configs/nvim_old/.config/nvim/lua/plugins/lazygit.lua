return {
  'kdheepak/lazygit.nvim',
  lazy = true,
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local width = math.floor(vim.o.columns * 0.95)
    local height = math.floor(vim.o.lines * 0.95)
    local border = 'double'

    local ok, laz = pcall(require, 'lazygit')
    if ok and type(laz.setup) == 'function' then
      laz.setup {
        float = {
          width = width,
          height = height,
          border = border,
        },
      }
      return
    end

    -- Fallback: create a simple LazyGit command that opens a floating terminal
    if vim.fn.exists ':LazyGit' == 0 then
      vim.api.nvim_create_user_command('LazyGit', function()
        local buf = vim.api.nvim_create_buf(false, true)
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)
        vim.api.nvim_open_win(buf, true, {
          relative = 'editor',
          width = width,
          height = height,
          row = row,
          col = col,
          style = 'minimal',
          border = border,
        })
        vim.fn.termopen 'lazygit'
        vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bd!<CR>', { silent = true, noremap = true })
      end, { desc = 'LazyGit' })
    end
  end,
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
}
