return {
  "danymat/neogen",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    languages = {
      javascript = { template = { annotation_convention = "jsdoc" } },
      typescript = { template = { annotation_convention = "tsdoc" } },
    },
  },
  keys = {
    {
      "<leader>cn",
      function()
        require("neogen").generate()
      end,
      desc = "Generate Annotations (Neogen)",
    },
  },
}
