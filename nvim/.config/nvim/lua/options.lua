vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.clipboard = 'unnamedplus'

vim.opt.timeoutlen = 500
vim.opt.updatetime = 200

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '80'
vim.opt.expandtab = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true

vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.wrap = true
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Add asterisks in block comments
vim.opt.formatoptions:append { 'r' }
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.g.copilot_enabled = false
--
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"


