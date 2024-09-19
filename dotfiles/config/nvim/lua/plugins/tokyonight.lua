return {
  "folke/tokyonight.nvim",
  config = function()
    require('tokyonight').setup({
      style = "night",
      transparent = true,
      styles = {
        floats ="night",
      },
    })
  -- require("tokyonight").load()
  end
}
