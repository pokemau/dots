return {}
-- return {
--   'romgrk/barbar.nvim',
--   version = '^1.0.0',
--   dependencies = {
--     'lewis6991/gitsigns.nvim', -- Optional: for git status
--     'nvim-tree/nvim-web-devicons', -- Optional: for file icons
--   },
--   init = function()
--     vim.g.barbar_auto_setup = false
--   end,
--   opts = {
--     icons = {
--       filetype = {
--         -- custom_colors = true,
--       },
--       current = {
--       },
--     },
--   },
--   config = function(_, opts)
--     require('barbar').setup(opts)
--     -- Optional: match backgrounds of buffer segments
--     -- vim.api.nvim_set_hl(0, 'BufferCurrent',       { bg = '#3f3836' })
--     -- vim.api.nvim_set_hl(0, 'BufferVisible',       { bg = '#32302f' })
--
--     vim.api.nvim_set_hl(0, 'BufferCurrent', { fg = '#d5c4a1', bg = '#3c3836' })
--     vim.api.nvim_set_hl(0, 'BufferInactive', { bg = '#282828' })
--
--     vim.api.nvim_set_hl(0, 'BufferTabpageFill', { bg = '#282828' }) -- Space between buffers and tabpage
--     vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '#ffffff' }) -- General tabline fill
--   end,
-- }
--