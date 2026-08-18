vim.pack.add({
  "https://github.com/kawre/leetcode.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",

  -- leetcode.nvim requires a picker. If you don't have one installed yet,
  -- uncomment the line below to install telescope.nvim
})

-- Optional: Set a keymap to open the LeetCode menu
vim.keymap.set("n", "<leader>lc", ":Leet<CR>", { noremap = true, silent = true })

require("leetcode").setup({
  lang = "python3"
})
