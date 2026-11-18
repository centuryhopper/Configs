-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set({ "n", "i" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Code action" })

local map = vim.keymap.set

-- Normal mode: move current line
map("n", "<C-A-Down>", "<Cmd>execute 'move .+' . v:count1<CR>==", { desc = "Move line down" })
map("n", "<C-A-Up>", "<Cmd>execute 'move .-' . (v:count1 + 1)<CR>==", { desc = "Move line up" })

-- Insert mode: move line and keep typing
map("i", "<C-A-Down>", "<Esc><Cmd>m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<C-A-Up>", "<Esc><Cmd>m .-2<CR>==gi", { desc = "Move line up" })

-- Visual mode: move the selected block, keep it selected
map("v", "<C-A-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<C-A-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = "Move selection up" })

-- hot key for commenting out code
for _, key in ipairs({ "<C-/>", "<C-_>" }) do
  vim.keymap.set("n", key, "gcc", { remap = true, desc = "Toggle comment" })
  vim.keymap.set("v", key, "gc", { remap = true, desc = "Toggle comment" })
end

-- VS Code-style fold all / unfold all
vim.keymap.set("n", "<C-k>0", "zM", { desc = "Fold all" })
vim.keymap.set("n", "<C-k>j", "zR", { desc = "Unfold all" })
vim.keymap.set("n", "<C-k><C-j>", "zR", { desc = "Unfold all" })

-- switching betweeen terminal and editor
-- vim.keymap.set({ "n", "t" }, "<C-Up>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
-- vim.keymap.set({ "n", "t" }, "<C-Down>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })

-- swapping what they do with each other
vim.keymap.set("n", "<leader>ft", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" })

vim.keymap.set("n", "<leader>fT", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })
