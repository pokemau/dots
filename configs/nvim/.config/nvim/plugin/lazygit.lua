vim.pack.add({
  'https://github.com/kdheepak/lazygit.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
})

vim.g.lazygit_floating_window_scaling_factor = 0.95
vim.g.lazygit_floating_window_border_chars = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }

vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
