return {
  'karb94/neoscroll.nvim',
  config = function()
    local keymap = {
      ["<C-u>"] = function() require('neoscroll').ctrl_u({ duration = 130 }) end,
      ["<C-d>"] = function() require('neoscroll').ctrl_d({ duration = 130 }) end,
    }
    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end
}
