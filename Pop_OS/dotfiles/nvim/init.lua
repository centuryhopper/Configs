-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.mapleader = " " -- sets space as the leader key

-- Ctrl-Tab / Ctrl-Shift-Tab: next/previous buffer, from normal or insert mode
vim.keymap.set({ "n", "i" }, "<C-Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set({ "n", "i" }, "<C-S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })

vim.keymap.set("n", "<C-w>", function()
  local buf = vim.api.nvim_get_current_buf()

  if vim.bo[buf].modified then
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
    if name == "" then
      name = "[No Name]"
    end

    local choice = vim.fn.confirm(
      ("Save changes to %s?"):format(name),
      "&Yes\n&No\n&Cancel",
      3 -- default: Cancel
    )

    if choice == 1 then
      vim.cmd.write()
    elseif choice == 2 then
      Snacks.bufdelete({ buf = buf, force = true })
      return
    else
      return -- Cancel (or Esc): do nothing
    end
  end

  Snacks.bufdelete(buf)
end, { desc = "Close buffer (tab), confirm if unsaved" })
