return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  config = function()
    require('mason-tool-installer').setup {
      ensure_installed = {
        'gopls',        -- goのLSP
        'volar',        -- vue(typescript)のLSP
        'phpcbf',       -- PHPのフォーマッタ phpactorではフォーマットできないため
        'intelephense', -- PHPのLSP
        'lua_ls',
        'ts_ls',
      },
    }
  end
}
