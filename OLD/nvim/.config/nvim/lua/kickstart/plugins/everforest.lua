---@diagnostic disable: missing-fields
return {
  'neanias/everforest-nvim',
  priority = 1000,
  config = function()
    local everforest = require 'everforest'

    everforest.setup {
      background = "hard",
      transparent_background_level = 0,
      disable_italic_comments = false,
      italics = true,
      ui_contrast = "high"
    }
    vim.cmd.colorscheme 'everforest'
  end,
}

