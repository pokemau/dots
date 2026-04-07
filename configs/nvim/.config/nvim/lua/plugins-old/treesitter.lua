-- return {}
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter",
	opts = {
		ensure_installed = { "bash", "c", "html" },
		auto_install = true,
		highlight = {
			enable = true,
		},
		indent = { enable = true },
	},
}
