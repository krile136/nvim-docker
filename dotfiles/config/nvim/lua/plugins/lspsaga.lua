return{
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup({
      symbol_in_winbar = {
        enable = false,
      },
      ui = {
        border = "rounded",
      },
      lightbulb = {
        enable = false,
      },
      floaterm = {
        height = 0.9,
        width = 1, 
      },
      finder = {
        max_height = 1,
        left_width = 0.3,
        right_width = 0.7,
      },
    })
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })

    local set = vim.keymap.set
    set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')                     -- 定義を表示
    set('n', 'gr', '<cmd>Lspsaga finder<CR>')                       -- 使用している箇所を表示、oでその箇所へジャンプ
    set('n', 'ge', '<cmd>Lspsaga show_line_diagnostics<CR>')        -- 行に出ている診断結果（エラーとか）を表示
    set('n', 'gl', '<cmd>Lspsaga diagnostic_jump_next<CR>')         -- 次の診断結果(エラーとか)へ移動
    set('n', 'gh', '<cmd>Lspsaga diagnostic_jump_prev<CR>')         -- 前の診断結果(エラーとか)へ移動
    set('n', 'ga', '<cmd>Lspsaga code_action<CR>')                  -- 利用できるコードアクションを表示
    set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>')              -- 変数の定義元にジャンプ
    set('n', 'gt', '<cmd>Lspsaga goto_type_definition<CR>')         -- 変数の型の定義元にジャンプ
    set('n', 'gn', '<cmd>Lspsaga rename<CR>')                       -- 変数名を一括変更
    set('n', 'gw', '<cmd>Lspsaga show_workspace_diagnostics<CR>')   -- workspaceの診断結果（エラーとか）を表示
    set('n', 'gb', '<cmd>Lspsaga show_buf_diagnostics<CR>')         -- workspaceの診断結果（エラーとか）を表示
    set('n', 'gp', '<cmd>Lspsaga winbar_toggle<CR>')                -- 画面上部に開いているファイルのパスの表示を切り替え
  end,
  dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
  }
}
