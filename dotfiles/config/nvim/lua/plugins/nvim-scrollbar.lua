return {
  "petertriho/nvim-scrollbar",
  dependencies = {
    "kevinhwang91/nvim-hlslens",
    "lewis6991/gitsigns.nvim",
  },
  config = function()
    local c = require('vscode.colors').get_colors()
    require("scrollbar").setup({
      marks = {
        Search = {
          color = c.vscOrange,
        },
      }
    })
    require("scrollbar.handlers.search").setup({})
    require('gitsigns').setup()
    require("scrollbar.handlers.gitsigns").setup()
  end
}
