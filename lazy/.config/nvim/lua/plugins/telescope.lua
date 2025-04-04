-- return {
--   "nvim-telescope/telescope.nvim",
--   keys = {
--     -- change a keymap
--     { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
--     -- disable the keymap to grep files
--     -- { "<leader>/", false },
--   },
-- }
return {
  "nvim-telescope/telescope.nvim",
  -- replace all Telescope keymaps with only one mapping
  keys = function()
    return {
      { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>pg", "<cmd>Telescope live_grep<cr>", desc = "Find Files" },
      { "<leader>pd", "<cmd>Telescope diagnostics<cr>", desc = "Find Files" },
    }
  end,
}
