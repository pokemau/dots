-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.keymap

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap.set("n", "<leader>q", ":bd<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap.set("i", "jk", "<ESC>", opts)
keymap.set("i", "<C-v>", "<C-r>+", opts)

-- Visual --
-- Stay in indent mode
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)
