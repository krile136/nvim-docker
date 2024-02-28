function map(mode, input, command, options)
  vim.api.nvim_set_keymap(mode, input, command, options)
end

map('n', '<Leader>h', '<C-w>h', {})
map('n', '<Leader>l', '<C-w>l', {})
map('n', '<Leader>j', '<C-w>j', {})
map('n', '<Leader>k', '<C-w>k', {})
map('n', '<Leader>f', '<C-w>W', {}) -- フローティングウィンドウへ移動
map('n', '<Leader>v', ':vsplit<CR>', {}) -- 画面を分割 
map('n', '<Leader>o', ':only<CR>', {}) -- 分割画面を一つにする
map('n', '<Leader>q', ':bd<CR>', {})

