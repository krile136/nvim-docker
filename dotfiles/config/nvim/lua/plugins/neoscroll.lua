return {
  'karb94/neoscroll.nvim',
  config = function()
    local keymap = {
      ["<C-u>"] = function() require('neoscroll').ctrl_u({ duration = 100, easing = 'sine' }) end,
      ["<C-d>"] = function() require('neoscroll').ctrl_d({ duration = 100, easing = 'sine' }) end,
    }
    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end
}
