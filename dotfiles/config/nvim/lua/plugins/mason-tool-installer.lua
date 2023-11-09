return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  config = function()
    require('mason-tool-installer').setup {
      ensure_installed = {
        'gopls',      -- goのLSP
        'phpactor',   -- PHPのLSP
        'volar',      -- vue(typescript)のLSP
        'phpcbf',     -- PHPのフォーマッタ phpactorではフォーマットできないため
      },
    }
  end
}
