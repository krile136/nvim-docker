--------------------- basic settings ---------------------
require('settings/basic')

--------------------- custom keymap ---------------------
require('settings/keymap')

--------------------- plugins ---------------------
require('settings/pluginSetup')

vim.o.termguicolors = true  -- nvim-colorizerのためにプラグインを読み込む前に設定する

local lazyOpts = {
 	ui = {
	  border = "rounded",
	},
}
require("lazy").setup({
  require('plugins/comment'),
  -- require('plugins/copilot-cmp'),  -- copilotより先に読み込む
  require('plugins/copilot'),
  require('plugins/copilotChat'),
  require('plugins/copilot-lualine'),
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
  require('plugins/tokyonight'),
  require('plugins/vscode'),
  require('plugins/render-markdown'),
  require('plugins/nvim-colorizer'),

  -- 後で読み込むことで正常に動くようになる
  require('plugins/modes'),
  require('plugins/indent-blankline'),
}, lazyOpts)


--------------------- NvimTreeの色設定 ---------------------
vim.cmd('hi NvimTreeExecFile guifg=#ffffff')

-- copilotの色設定
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})

--------------------- floatの背景色をなくす ---------------------
vim.cmd [[
  highlight NormalFloat guibg=NONE
  highlight FloatBorder guibg=NONE
]]

-- Define highlight groups for icons
vim.cmd('highlight LspIcon guifg=#99FF99 guibg=#303030')
vim.cmd('highlight TimeIcon guifg=#99FFFF guibg=#303030')

vim.cmd('highlight VertSplit guifg=#808080')

vim.filetype.add({
  extension = {
    cls = 'apex',
    trigger = 'apex',
    cmp = 'html',
  }
})

-- Escキーを送信するマッピングを作成(Copilotのリセット用)
vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>', { noremap = true, silent = true })

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


