-- return {
--   {
--     'CopilotC-Nvim/CopilotChat.nvim',
--     dependencies = {
--       { 'github/copilot.vim' },
--       { 'nvim-lua/plenary.nvim', branch = 'master' },
--     },
--     opts = {
--       -- model = 'claude-sonnet-4',
--     },
--     config = function(_, opts)
--       require('CopilotChat').setup(opts)
--
--       vim.keymap.set('n', '<leader>c', ':CopilotChat<CR>', { noremap = true, silent = true })
--     end,
--   },
-- }

return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    opts = {
      -- model = 'claude-sonnet-4',
      mappings = {
        close = {
          normal = 'q',
          insert = '<C-c>',
          callback = function()
            local copilot = require 'CopilotChat'
            -- Check if this is the last window
            if #vim.api.nvim_tabpage_list_wins(0) == 1 then
              -- Create a new empty buffer before closing
              vim.cmd 'enew'
            end
            copilot.close()
          end,
        },
      },
    },
    config = function(_, opts)
      require('CopilotChat').setup(opts)

      vim.keymap.set('n', '<leader>c', ':CopilotChat<CR>', { noremap = true, silent = true })
    end,
  },
}
