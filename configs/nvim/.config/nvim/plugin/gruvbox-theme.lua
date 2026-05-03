vim.pack.add({
  'https://github.com/ellisonleao/gruvbox.nvim'
})

require('gruvbox').setup({
  undercurl = true,
  underline = true,
  bold = false,
  italic = {
    strings = false,
    comments = false,
    operators = false,
    folds = false,
    emphasis = false,
  },
  strikethrough = true,
  invert_selection = true,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = true,
  inverse = true,
  contrast = "hard",
  palette_overrides = {
    dark0_hard = "#17191A",
  },
  dim_inactive = false,
  transparent_mode = false,

})
vim.cmd.colorscheme("gruvbox")
