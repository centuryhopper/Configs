return {
  "okuuva/auto-save.nvim",
  enabled = false,
  version = "^1.0.0",
  cmd = "ASToggle",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    debounce_delay = 1000, -- ms after you stop editing
  },
}
