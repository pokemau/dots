-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

local keymap = vim.keymap

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Better window navigation
keymap.set('n', '<C-h>', '<C-w>h', opts)
keymap.set('n', '<C-j>', '<C-w>j', opts)
keymap.set('n', '<C-k>', '<C-w>k', opts)
keymap.set('n', '<C-l>', '<C-w>l', opts)

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- LEETCODE
keymap.set({ 'n', 'i' }, "<C-'>", ':Leet test<CR>', opts)

keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Save with Ctrl + S
keymap.set('n', '<C-s>', ':w <CR>', opts)

-- Resize with arrows
keymap.set('n', '<C-Up>', ':resize +2<CR>', opts)
keymap.set('n', '<C-Down>', ':resize -2<CR>', opts)
keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Navigate buffers
keymap.set('n', '<S-l>', ':bnext<CR>', opts)
keymap.set('n', '<S-h>', ':bprevious<CR>', opts)

-- Insert --
-- Press jk fast to enter
keymap.set('i', 'jk', '<ESC>', opts)
keymap.set('i', '<C-v>', '<C-r>+', opts)

-- Visual --
-- Stay in indent mode
keymap.set('v', '<', '<gv', opts)
keymap.set('v', '>', '>gv', opts)

-- Move text up and down
keymap.set('v', '<A-j>', ':m .+1<CR>==', opts)
keymap.set('v', '<A-k>', ':m .-2<CR>==', opts)
keymap.set('v', 'p', '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap.set('x', 'J', ":move '>+1<CR>gv-gv", opts)
keymap.set('x', 'K', ":move '<-2<CR>gv-gv", opts)
keymap.set('x', '<A-j>', ":move '>+1<CR>gv-gv", opts)
keymap.set('x', '<A-k>', ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap.set('t', '<C-h>', '<C-\\><C-N><C-w>h', term_opts)
keymap.set('t', '<C-j>', '<C-\\><C-N><C-w>j', term_opts)
keymap.set('t', '<C-k>', '<C-\\><C-N><C-w>k', term_opts)
keymap.set('t', '<C-l>', '<C-\\><C-N><C-w>l', term_opts)

keymap.set('n', 'x', '"_x')

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Select all
keymap.set('n', '<C-a>', 'ggVG')

-- New tab
keymap.set('n', 'te', ':tabedit<Return>', term_opts)

-- Split window
keymap.set('n', 'ss', ':split<Return><C-w>w', term_opts)
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', term_opts)

-- Resize window
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')

-- vim: ts=2 sts=2 sw=2 et
