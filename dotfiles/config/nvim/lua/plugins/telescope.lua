return {
  'nvim-telescope/telescope.nvim', tag = '0.1.3',
  dependencies = { 
    'nvim-lua/plenary.nvim'
  },
  config = function()
    local builtin = require('telescope.builtin')
    -- C-hとC-lはBTTにより仮想デスクトップの移動に割り当てているので使用しないように！
    -- control + 右手のキーで対応したいがコンフリクトも多い要調整
    --
    vim.keymap.set('n', '<C-i>', builtin.live_grep, {})   -- ファイル内文字列検索
    vim.keymap.set('n', '<C-y>', builtin.grep_string, {})     -- カーソル下の単語検索 
    vim.keymap.set('n', '<C-g>', builtin.git_status, {})     -- git statusの結果一覧
    vim.keymap.set('n', '<C-k>', builtin.spell_suggest, {})     -- spellの候補
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

    vim.keymap.set("n", "<C-j>", function ()
      require("telescope").extensions.smart_open.smart_open{
        cwd_only = true,
        theme = "dropdown",
      } 
    end, { noremap = true, silent = true })

    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-d>"] = require('telescope.actions').delete_buffer,
            ["<C-p>"] = function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-r>0", true, true, true), 'i', true)
            end
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
        oldfiles = {
          layout_config = { width = 0.8},
          theme = "dropdown",
        },
        git_status = {
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
