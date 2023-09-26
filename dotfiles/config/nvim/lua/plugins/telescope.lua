return {
  'nvim-telescope/telescope.nvim', tag = '0.1.3',
  dependencies = { 
    'nvim-lua/plenary.nvim'
  },
  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<S-f>', builtin.find_files, {}) -- ファイル名検索
    vim.keymap.set('n', '<S-h>', builtin.live_grep, {})   -- ファイル内文字列検索
    vim.keymap.set('n', '<S-j>', builtin.buffers, {})     -- buffer内検索
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})   

    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          }
        }
      }
    })

  end
}
