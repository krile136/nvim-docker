--------------------- basic settings ---------------------
require('settings/basic')

--------------------- custom keymap ---------------------
require('settings/keymap')

--------------------- plugins ---------------------
require('settings/pluginSetup')

require("lazy").setup({
  require('plugins/fidget'),
  require('plugins/lspconfig'),
  require('plugins/lualine'),
  require('plugins/mason-tool-installer'),
  require('plugins/mason'),
  require('plugins/neoscroll'),
  require('plugins/noice'),  -- かっこいいけど重いので一旦使わない
  require('plugins/nvim-autopairs'),
  require('plugins/nvim-cmp'),
  require('plugins/nvim-scrollbar'),
  require('plugins/nvim-simple-formatter'),
  require('plugins/nvim-tree'),
  require('plugins/nvim-treesitter'),
  require('plugins/telescope'),
  require('plugins/vscode'),
}, opts)


