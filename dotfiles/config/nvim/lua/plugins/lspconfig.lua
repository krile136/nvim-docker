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

    nvim_lsp['intelephense'].setup{
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

    nvim_lsp['ts_ls'].setup{
        on_attach = custom_attach,
        on_init = function(client, _)
            client.server_capabilities.semanticTokensProvider = nil
        end,
        flag = {
            debounce_text_changes = 150,
        }
    }

nvim_lsp['apex_ls'].setup{
  cmd = { 'java', '-jar', '/root/.local/share/nvim/mason/share/apex-language-server/apex-jorje-lsp.jar' },
  filetypes = { 'apex' },
  on_attach = custom_attach,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    apex = {
      enable_semantic_errors = true,
      enable_completion_statistics = true,
    }
  }
}

    -- keyboard shortcut
    -- ctrl + o で定義ジャンプ元に戻れる
    vim.keymap.set('n', 'gj', '<cmd>lua vim.lsp.buf.definition()<CR>') -- 定義元にジャンプ
    vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.format{async=true}<CR>') -- フォーマットを実施（LSPが対応していれば） 
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>') -- インターフェースの実装を一覧表示

 end
}
