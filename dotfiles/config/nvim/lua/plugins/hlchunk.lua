return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        duration = 0,
        delay = 0,
        style = {
          "#ADD8E6",
        }
      },
      indent = {
        enable = true,
      }
    })
  end
}
