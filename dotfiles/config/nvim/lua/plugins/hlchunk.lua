return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        priority = 15,
        style = {
          { fg = "#ADD8E6" },
          { fg = "#c21f30" },
        },
        use_treesitter = true,
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = ">",
        },
        textobject = "",
        max_file_size = 1024 * 1024,
        error_sign = true,
        -- animation related
        duration = 0,
        delay = 0,
      },
      indent = {
        enable = true,
      }
    })
  end
}
