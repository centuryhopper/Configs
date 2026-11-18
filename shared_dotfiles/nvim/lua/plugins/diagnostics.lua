return {
  -- turn off LazyVim's built-in end-of-line diagnostics
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = { analysis = { typeCheckingMode = "basic" } }, -- or "off"
          },
        },
      },
      diagnostics = {
        virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
        signs = { severity = { min = vim.diagnostic.severity.ERROR } },
        underline = { severity = { min = vim.diagnostic.severity.ERROR } },
      },
    },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      options = {
        overflow = { mode = "wrap" }, -- wrap long messages instead of running off-screen
        multilines = { enabled = true }, -- show diagnostics on every line, not just the cursor line
      },
    },
  },
}
