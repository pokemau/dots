return {
	"Mofiqul/vscode.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("vscode").setup({
			group_overrides = {
				Normal = { bg = "#17191A" },
				NormalFloat = { bg = "#1e1e1e" },
				FloatBorder = { bg = "#1e1e1e", fg = "#3e3e3e" },
				Pmenu = { bg = "#1e1e1e" },
				PmenuSel = { bg = "#264f78" },
			},
		})
		vim.cmd.colorscheme("vscode")
	end,
}
