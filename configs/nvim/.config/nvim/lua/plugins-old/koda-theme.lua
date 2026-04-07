return {
	"oskarnurm/koda.nvim",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("koda").setup({
			-- colors = {
			-- 	bg = "#101010", -- editor background
			-- 	fg = "#b0b0b0", -- primary text color
			-- 	line = "#272727", -- line highlights
			-- 	paren = "#4d4d4d", -- matching brackets highlight
			-- 	keyword = "#777777", -- language syntax
			-- 	dim = "#50585d", -- line numbers, inlay hints
			-- 	comment = "#50585d", -- code comments
			-- 	border = "#fafafa", -- floating window borders
			-- 	emphasis = "#fafafa", -- bold text and prominent UI elements
			-- 	func = "#fafafa", -- function names and headings
			-- 	string = "#fafafa", -- string literals
			-- 	const = "#d9ba73", -- numbers, booleans, and constants
			-- 	highlight = "#0058d0", -- search results and selection base
			-- 	info = "#8ebeec", -- diagnostic hints and informative icons
			-- 	success = "#86cd82", -- added git lines and positive diagnostics
			-- 	warning = "#d9ba73", -- modified git lines and warning diagnostics
			-- 	danger = "#ff7676", -- removed git lines and error diagnostics
			-- },
		})
		-- vim.cmd("colorscheme koda")

	end,
}
