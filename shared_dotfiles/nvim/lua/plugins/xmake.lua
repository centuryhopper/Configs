return {
  -- xmake type definitions for the Lua language server
  { "LelouchHe/xmake-luals-addon", lazy = true },

  {
    "folke/lazydev.nvim",
    opts = function(_, opts)
      opts.library = opts.library or {}
      table.insert(opts.library, {
        path = "xmake-luals-addon/library",
        files = { "xmake.lua" },
      })
    end,
  },
}
