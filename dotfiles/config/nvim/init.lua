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
  require('plugins/lualine'),
  require('plugins/fidget'),
  require('plugins/lsp-signature'),
  require('plugins/lspconfig'),
  require('plugins/lspsaga'),
  require('plugins/mason-tool-installer'),
  require('plugins/mason'),
  require('plugins/neoscroll'),
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
  require('plugins/flash'),
  require('plugins/outline'),

  -- 後で読み込むことで正常に動くようになる
  require('plugins/modes'),
  -- require('plugins/indent-blankline'),
  require('plugins/hlchunk'),
}, lazyOpts)

--------------------- floatの背景色をなくす ---------------------
vim.cmd [[
  highlight NormalFloat guibg=NONE
  highlight FloatBorder guibg=NONE
]]

-- Define highlight groups for icons
vim.cmd('highlight LspIcon guifg=#99FF99 guibg=#303030')
vim.cmd('highlight TimeIcon guifg=#99FFFF guibg=#303030')
vim.cmd('highlight GitAlertIcon guifg=#FFFF00 guibg=#303030')
vim.cmd('highlight GitIcon guifg=#F58220 guibg=#303030')
vim.cmd('highlight EncodingIcon guifg=#ba82e3 guibg=#303030')
vim.cmd('highlight BatteryChargingIcon guifg=#FFFF00 guibg=#303030')
vim.cmd('highlight BatteryNoneIcon guifg=#8B0000 guibg=#303030')
vim.cmd('highlight BatteryDangerIcon guifg=#8B0000 guibg=#303030')
vim.cmd('highlight BatteryWarningIcon guifg=#BBBB44 guibg=#303030')
vim.cmd('highlight BatteryGoodIcon guifg=#66AACC guibg=#303030')
vim.cmd('highlight BatteryFullIcon guifg=#3BAF75 guibg=#303030')
vim.cmd('highlight StatusText guifg=#C5C5C5 guibg=#303030')


vim.cmd('highlight VertSplit guifg=#808080')


vim.filetype.add({
  extension = {
    cls = 'apex',
    trigger = 'apex',
    cmp = 'html',
  }
})

--------------------- semantic highlighting ---------------------
require('settings/semantic-highlighting')

require('settings/specific-word-highlighting')


-- require('settings/rainbow-ebiten')

-- Insert modeからNormal modeに戻った時に自動保存
vim.api.nvim_create_autocmd({ "InsertLeave", "TextYankPost", "TextChanged" }, {
  pattern = "*",
  callback = function()
    if vim.fn.expand('%:e') ~= '' and vim.bo.modified then
      vim.cmd("w")
    end
  end,
})
