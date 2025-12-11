-- File: ~/.config/nvim/lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        -- Disable diagnostics for markdown files
        markdown = function(_, _)
          vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*.md",
            callback = function()
              vim.diagnostic.disable(0)
            end,
          })
          return true
        end,
      },
    },
  },
}
