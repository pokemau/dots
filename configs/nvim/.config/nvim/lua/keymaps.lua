local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.keymap

keymap.set("n", "j", "gj", { silent = true })
keymap.set("n", "k", "gk", { silent = true })

-- Press jk fast to enter
keymap.set("i", "jk", "<ESC>", opts)
-- Paste with Ctrl + V
keymap.set("i", "<C-v>", "<C-r>+", opts)
-- Close tab
keymap.set("n", "<leader>q", ":bd<CR>", opts)
-- Clear search highlights
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Save with Ctrl + S
keymap.set("n", "<C-s>", ":w <CR>", opts)

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- CTRL+<hjkl> to switch between windows
keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
-- Stay in indent mode
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)
-- Move text up and down
keymap.set("v", "<A-j>", ":m .+1<CR>==", opts)
keymap.set("v", "<A-k>", ":m .-2<CR>==", opts)
-- Better terminal navigation
keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")
-- Select all
keymap.set("n", "<leader>a", "ggVG")
-- New tab
keymap.set("n", "te", ":tabedit<Return>", term_opts)
-- Split window
keymap.set("n", "ss", ":split<Return><C-w>w", term_opts)
keymap.set("n", "sv", ":vsplit<Return><C-w>w", term_opts)
-- Resize window
keymap.set("n", "<C-left>", "<C-w><")
keymap.set("n", "<C-right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")
