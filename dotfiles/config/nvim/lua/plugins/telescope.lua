return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.3',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
    local builtin = require('telescope.builtin')
    -- C-hとC-lはBTTにより仮想デスクトップの移動に割り当てているので使用しないように！
    -- control + 右手のキーで対応したいがコンフリクトも多い要調整
    --
    vim.keymap.set('n', '<C-i>', builtin.live_grep, {})   -- ファイル内文字列検索
    vim.keymap.set('n', '<C-p>', builtin.grep_string, {}) -- カーソル下の単語検索
    vim.keymap.set('n', '<C-g>', builtin.git_status, {})  -- git statusの結果一覧
    vim.keymap.set('n', '<C-k>', builtin.buffers, {})     -- spellの候補
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

    -- 定義元にジャンプ(telescopeだとフロートウィンドウで出せるのでこっちで使用する)
    vim.keymap.set('n', 'gj', '<cmd>Telescope lsp_definitions<CR>')      -- 定義元にジャンプ
    vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>')       -- 使用している箇所を表示
    vim.keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>') -- 変数の型の定義元にジャンプ
    vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>')   -- インターフェースの実装を一覧表示
    vim.keymap.set('n', 'gp', '<cmd>Telescope lsp_incoming_calls<CR>')  -- 関数の呼び出し元を表示(referencesと似ているが、関数の呼び出し元に絞られる)
    vim.keymap.set('n', 'go', '<cmd>Telescope lsp_outgoing_calls<CR>')  -- 関数の呼び出し先を表示(関数がどの関数やメソッドを呼び出しているかを絞ることができる）

    vim.keymap.set("n", "<C-j>", function()
        require("telescope").extensions.smart_open.smart_open {
          cwd_only = true,
          theme = "dropdown",
          show_scores = false,
          ignore_patterns = {
            "*.cls-meta.xml",
            "*.git/*",
            "*build/*",
            "*debug/*",
            "*.pdf",
            "*.ico",
            "*.class",
            "*~",
            "~:",
            "*.jar",
            "*.node",
            "*.lock",
            "*.gz",
            "*.zip",
            "*.7z",
            "*.rar",
            "*.lzma",
            "*.bz2",
            "*.rlib",
            "*.rmeta",
            "*.DS_Store",
            "*.cur",
            "*.png",
            "*.jpeg",
            "*.jpg",
            "*.gif",
            "*.bmp",
            "*.avif",
            "*.heif",
            "*.jxl",
            "*.tif",
            "*.tiff",
            "*.ttf",
            "*.otf",
            "*.woff*",
            "*.sfd",
            "*.pcf",
            "*.ico",
            "*.svg",
            "*.ser",
            "*.wasm",
            "*.pack",
            "*.pyc",
            "*.apk",
            "*.bin",
            "*.dll",
            "*.pdb",
            "*.db",
            "*.so",
            "*.spl",
            "*.min.js",
            "*.min.gzip.js",
            "*.so",
            "*.doc",
            "*.swp",
            "*.bak",
            "*.ctags",
            "*.doc",
            "*.ppt",
            "*.xls",
            "*.pdf",
          },
        }
      end,
      { noremap = true, silent = true })

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
          layout_config = { width = 0.8 },
          theme = "dropdown",
        },
        live_grep = {
          layout_config = { width = 0.8 },
          theme = "dropdown",
        },
        grep_string = {
          layout_config = { width = 0.8 },
          theme = "dropdown",
        },
        buffers = {
          layout_config = { width = 0.8 },
          theme = "dropdown",
        },
        oldfiles = {
          layout_config = { width = 0.8 },
          theme = "dropdown",
        },
        git_status = {
          layout_config = { width = 0.8 },
          theme = "dropdown",
        },
        lsp_references = {
          layout_config = { width = 0.8 },
          theme = "dropdown",
        },
        lsp_implementations = {
          layout_config = { width = 0.8 },
          theme = "dropdown",
        },
      },

    })
  end
}
