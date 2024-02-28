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
    vim.keymap.set('n', '<S-w>', builtin.grep_string, {})     -- カーソル下の単語検索 
    vim.keymap.set('n', '<S-l>', builtin.oldfiles, {})     -- 最近使ったファイル 
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

    vim.keymap.set('n', 'gr', builtin.lsp_references, {}) -- カーソル下の変数やメソッドや関数を使用している箇所一覧
    vim.keymap.set('n', 'gi', builtin.lsp_implementations, {}) -- カーソル下の単語の実装一覧

    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ['<c-d>'] = require('telescope.actions').delete_buffer
          }
        }
      },
      pickers = {
        find_files = {
          layout_config = { width = 0.8},
          theme = "dropdown",
        },
        live_grep = {
          layout_config = { width = 0.8},
          theme = "dropdown",
        },
        grep_string = {
          layout_config = { width = 0.8},
          theme = "dropdown",
        },
        buffers = {
          layout_config = { width = 0.8},
          theme = "dropdown",
        },
        lsp_references = {
          layout_config = { width = 0.8},
          theme = "dropdown",
        },
        lsp_implementations = {
          layout_config = { width = 0.8},
          theme = "dropdown",
        },
      },

    })

  end
}
