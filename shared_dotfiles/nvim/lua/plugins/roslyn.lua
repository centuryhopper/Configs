return {
  {
    "mason-org/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry", -- provides the roslyn package
      },
    },
  },
  { "seblyng/roslyn.nvim", ft = { "cs", "razor" }, opts = {} },
}
