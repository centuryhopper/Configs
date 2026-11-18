return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()
    local set = vim.keymap.set

    -- Alt+click to add/remove cursors (like VS Code)
    set("n", "<A-LeftMouse>", mc.handleMouse)
    set("n", "<A-LeftDrag>", mc.handleMouseDrag)
    set("n", "<A-LeftRelease>", mc.handleMouseRelease)

    -- Add a cursor on the line above/below
    set({ "n", "x" }, "<A-k>", function()
      mc.lineAddCursor(-1)
    end)
    set({ "n", "x" }, "<A-j>", function()
      mc.lineAddCursor(1)
    end)

    -- Add a cursor at the next match of the word under the cursor (like Ctrl+D)
    set({ "n", "x" }, "<leader>n", function()
      mc.matchAddCursor(1)
    end)

    -- Esc clears the extra cursors
    mc.addKeymapLayer(function(layerSet)
      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)
  end,
}
