return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim'
  },
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded"
      }
    })
    require("mason-lspconfig").setup({
      ensure_installed = {
        'gopls','phpactor', 'volar'
      },
    })
  end
}
