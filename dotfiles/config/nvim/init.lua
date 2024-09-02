--------------------- basic settings ---------------------
require('settings/basic')

--------------------- custom keymap ---------------------
require('settings/keymap')

--------------------- plugins ---------------------
require('settings/pluginSetup')

local lazyOpts = {
 	ui = {
	  border = "rounded",
	},
}
require("lazy").setup({
  require('plugins/comment'),
  require('plugins/copilot-cmp'),  -- copilotより先に読み込む
  require('plugins/copilot'),
  require('plugins/copilotChat'),
  require('plugins/fidget'),
  require('plugins/hlargs'),
  require('plugins/lsp-signature'),
  require('plugins/lspconfig'),
  require('plugins/lspsaga'),
  require('plugins/lualine'),
  require('plugins/mason-tool-installer'),
  require('plugins/mason'),
  require('plugins/neoscroll'),
  require('plugins/noice'),
  require('plugins/none-ls'),
  -- require('plugins/nvim-autopairs'),   -- copilotと競合 カッコは手で入れよう
  require('plugins/nvim-cmp'),
  require('plugins/nvim-scrollbar'),
  require('plugins/nvim-tree'),
  require('plugins/nvim-treesitter'),
  require('plugins/smart-open'),
  require('plugins/telescope'),
  require('plugins/vscode'),

  -- 後で読み込むことで正常に動くようになる
  require('plugins/modes'),
  require('plugins/indent-blankline'),
 
}, lazyOpts)

--------------------- NvimTreeの色設定 ---------------------
vim.cmd('hi NvimTreeExecFile guifg=#ffffff')

--------------------- floatの背景色をなくす ---------------------
vim.cmd [[
  highlight NormalFloat guibg=NONE
  highlight FloatBorder guibg=NONE
]]


vim.filetype.add({
  extension = {
    cls = 'apex',
    trigger = 'apex',
  }
})

---------------------- clipboardをホストマシンと共有する -------------
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
 }
