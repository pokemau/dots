vim.opt.clipboard = "unnamedplus"


vim.opt.autoread = true
vim.opt.updatetime = 300

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	command = "silent! checktime",
})
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.expandtab = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true

vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"

-- Set Cursor highlight after any colorscheme loads
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "Cursor", { reverse = true })
	end,
})

-- LSP Signature help highlight
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
	fg = "#ffffff",
	bg = "#5c6370",
	bold = true,
	italic = true,
})
