
-- return {
-- 	"nvim-neo-tree/neo-tree.nvim",
-- 	dependencies = {
-- 		"nvim-lua/plenary.nvim",
-- 		"nvim-tree/nvim-web-devicons",
-- 		"MunifTanjim/nui.nvim",
-- 	},
-- 	config = function()
-- 		require("neo-tree").setup({
-- 			filesystem = {
-- 				filtered_items = {
-- 					visible = true,
-- 					hide_dotfiles = false,
-- 					hide_gitignored = false,
-- 				},
-- 			},
-- 			window = {
-- 				mappings = {
-- 					["s"] = "set_root",
-- 				},
-- 			},
-- 		})
-- 		vim.keymap.set("n", "<leader>e", ":Neotree toggle reveal<CR>", { noremap = true, silent = true })
-- 	end,
-- }


vim.pack.add({
  {
    src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    version = vim.version.range('3')
  },
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

		vim.keymap.set("n", "<leader>e", ":Neotree toggle reveal<CR>", { noremap = true, silent = true })

require('neo-tree').setup({
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
			window = {
				mappings = {
					["s"] = "set_root",
				},
			},
})
