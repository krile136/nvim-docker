return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local null_ls = require('null-ls')
    local sources = {
      null_ls.builtins.formatting.prettier.with({
        filetypes = { "apex" }, -- Apexファイルに対してprettierを使用
        extra_args = { "--print-width", "115" }, -- 追加のオプション
      }),
      null_ls.builtins.formatting.prettier.with({
        filetypes = { "html" }, -- HTMLファイルに対してprettierを使用
      }),
    }

    null_ls.setup({
      sources = sources,
    })

    -- フォーマット用のキーバインドを設定
    vim.api.nvim_set_keymap('n', '<Leader>ff', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', { noremap = true, silent = true })
  end,
}
