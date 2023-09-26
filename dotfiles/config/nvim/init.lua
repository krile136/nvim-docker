--------------------- basic settings ---------------------
require('settings/basic')

--------------------- custom keymap ---------------------
require('settings/keymap')

--------------------- plugins ---------------------
require('settings/pluginSetup')

require("lazy").setup({
  require('plugins/nvim-tree'),
  require('plugins/lualine'),
  require('plugins/vscode'),
  require('plugins/telescope'),
  require('plugins/noice'),
  require('plugins/lspconfig'),
  require('plugins/mason'),
  require('plugins/neoscroll'),
  require('plugins/nvim-cmp'),
  require('plugins/nvim-treesitter'),
  require('plugins/nvim-scrollbar'),
  require('plugins/nvim-autopairs'),
  -- require('plugins/bufferline'),
}, opts)


