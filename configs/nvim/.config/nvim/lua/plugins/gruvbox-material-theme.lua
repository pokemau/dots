return {
  "sainnhe/gruvbox-material",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.gruvbox_material_background = "hard"
    vim.g.gruvbox_material_better_performance = true
    vim.g.gruvbox_material_enable_italic = false
    vim.g.gruvbox_material_disable_italic_comment = true
    vim.g.gruvbox_material_diagnostic_virtual_text = "colored"

    vim.g.gruvbox_material_colors_override = {
      bg0 = { "#17191A", "234" },
    }

    vim.cmd.colorscheme("gruvbox-material")
  end,
}
