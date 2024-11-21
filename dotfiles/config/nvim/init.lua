_G.vim = vim
--------------------- basic settings ---------------------
require('settings/basic')

--------------------- custom keymap ---------------------
require('settings/keymap')

--------------------- plugins ---------------------
require('settings/pluginSetup')

vim.o.termguicolors = true -- nvim-colorizerのためにプラグインを読み込む前に設定する

local lazyOpts = {
  ui = {
    border = "rounded",
  },
}
require("lazy").setup({
  require('plugins/comment'),
  require('plugins/copilot'),
  require('plugins/copilotChat'),
  require('plugins/copilot-lualine'),
  require('plugins/fidget'),
  require('plugins/lsp-signature'),
  require('plugins/lspconfig'),
  require('plugins/lspsaga'),
  require('plugins/lualine'),
  require('plugins/mason-tool-installer'),
  require('plugins/mason'),
  require('plugins/neoscroll'),
  require('plugins/noice'),
  require('plugins/none-ls'),
  require('plugins/nvim-cmp'),
  require('plugins/nvim-scrollbar'),
  require('plugins/nvim-treesitter'),
  require('plugins/smart-open'),
  require('plugins/telescope'),
  require('plugins/vscode'),
  require('plugins/render-markdown'),
  require('plugins/nvim-colorizer'),
  require('plugins/oil'),
  require('plugins/oil-git-status'),
  require('plugins/git-blame'),

  -- 後で読み込むことで正常に動くようになる
  require('plugins/modes'),
  require('plugins/indent-blankline'),

  require('plugins/hlargs'),
}, lazyOpts)

--------------------- NvimTreeの色設定 ---------------------
vim.cmd('hi NvimTreeExecFile guifg=#ffffff')

--------------------- floatの背景色をなくす ---------------------
vim.cmd [[
  highlight NormalFloat guibg=NONE
  highlight FloatBorder guibg=NONE
]]

-- Define highlight groups for icons
vim.cmd('highlight LspIcon guifg=#99FF99 guibg=#303030')
vim.cmd('highlight TimeIcon guifg=#99FFFF guibg=#303030')
vim.cmd('highlight GitIcon guifg=#F58220 guibg=#303030')
vim.cmd('highlight GitAlertIcon guifg=#FFFF00 guibg=#303030')
vim.cmd('highlight EncodingIcon guifg=#ba82e3 guibg=#303030')
vim.cmd('highlight BatteryNoneIcon guifg=#8B0000 guibg=#303030')
vim.cmd('highlight BatteryDangerIcon guifg=#8B0000 guibg=#303030')
vim.cmd('highlight BatteryWarningIcon guifg=#BBBB44 guibg=#303030')
vim.cmd('highlight BatteryGoodIcon guifg=#66AACC guibg=#303030')
vim.cmd('highlight BatteryFullIcon guifg=#3BAF75 guibg=#303030')

-- Define colors for each heading level
vim.cmd('highlight RenderMarkdownH1Bg guibg=#FFCCCC')
vim.cmd('highlight RenderMarkdownH2Bg guibg=#FFDDCC')
vim.cmd('highlight RenderMarkdownH3Bg guibg=#FFEECC')
vim.cmd('highlight RenderMarkdownH4Bg guibg=#FFFFCC')
vim.cmd('highlight RenderMarkdownH5Bg guibg=#EEFFCC')
vim.cmd('highlight RenderMarkdownH6Bg guibg=#DDFFCC')

-- Update the existing links to use the new colors
vim.cmd('highlight link RenderMarkdownH1 RenderMarkdownH1Bg')
vim.cmd('highlight link RenderMarkdownH2 RenderMarkdownH2Bg')
vim.cmd('highlight link RenderMarkdownH3 RenderMarkdownH3Bg')
vim.cmd('highlight link RenderMarkdownH4 RenderMarkdownH4Bg')
vim.cmd('highlight link RenderMarkdownH5 RenderMarkdownH5Bg')
vim.cmd('highlight link RenderMarkdownH6 RenderMarkdownH6Bg')


-- 特定の拡張子を別の拡張子として扱う
vim.filetype.add({
  extension = {
    cls = 'apex',
    trigger = 'apex',
    cmp = 'html',
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

--------------------- semantic highlighting ---------------------
require('settings/semantic-highlighting')

