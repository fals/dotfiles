-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Open Git Diff" })
vim.keymap.set("n", "<leader>gD", ":DiffviewClose<CR>", { desc = "Close Git Diff" })
vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>", { desc = "File History" })
