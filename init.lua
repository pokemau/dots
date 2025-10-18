vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.opt.clipboard = "unnamedplus"

if vim.g.vscode then
	vim.keymap.set("n", "<Esc>", ":nohl<CR>", { silent = true })
end

-- vim.opt.mouse = 'a'
-- vim.opt.breakindent = true
-- vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '80'
vim.opt.expandtab = true
vim.opt.scrolloff = 10
--
--
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
-- vim.opt.shiftwidth = 2
-- vim.opt.tabstop = 2
