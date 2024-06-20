return {
 "neovim/nvim-lspconfig",
  config = function()
    nvim_lsp = require('lspconfig')

    local custom_attach = function(client, bufnr)
      require('lsp_signature').on_attach({
        bind = true,
        handler_opts = {
          border = "rounded"
        }
      }, bufnr)
    end

    nvim_lsp['phpactor'].setup{
        on_attach = custom_attach,
        flags = {
          debounce_text_changes = 150,
          },
        settings = {}
    }

    nvim_lsp['gopls'].setup{
        on_attach = custom_attach,
        flags = {
          debounce_text_changes = 150,
          },
        settings = {gopls = {
          buildFlags =  {"-tags=js wasm"}
        }}
    }

    nvim_lsp['volar'].setup{
        on_attach = custom_attach,
        flags = {
          debounce_text_changes = 150,
          },
        settings = {}
    }


    -- keyboard shortcut
    -- ctrl + o で定義ジャンプ元に戻れる
    vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>') -- 定義を表示
    vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>') -- フォーマットを実施
    vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.format{async=true}<CR>') -- フォーマットを実施  PHPだと聞かないので別プラグイン(ale)で実施。今はgo専用
    -- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>') --  参照しているファイル一覧を表示 → telescopeの機能を使用
    vim.keymap.set('n', 'gj', '<cmd>lua vim.lsp.buf.definition()<CR>') -- 定義元にジャンプ
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    -- vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>') -- 実装元へのジャンプ　具体的には、interfaceをimplementsしている実装先のファイル一覧を表示  → telescopeの機能を使用
    vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')  -- これも定義元？タイプの定義元なので変数にいけるかも
    vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>') -- 変数名を一括して変更できる
    vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>') -- LSPで検知したエラー内容についてできるアクション一覧を表示する
    vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>') -- エラーが起きている上でコマンドを打つとエラー内容がホバーで表示される
    vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')

 end
}
