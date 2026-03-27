function map(mode, input, command, options)
  vim.api.nvim_set_keymap(mode, input, command, options)
end

map('n', '<Leader>h', '<C-w>h', {})
map('n', '<Leader>l', '<C-w>l', {})
map('n', '<Leader>j', '<C-w>j', {})
map('n', '<Leader>k', '<C-w>k', {})
map('n', '<Leader>f', '<C-w>W', {}) -- フローティングウィンドウへ移動
map('n', '<Leader>v', '<Cmd>vsplit<CR>', {}) -- 画面を縦分割 
map('n', '<Leader>s', '<Cmd>split<CR>', {}) -- 画面を横分割 
map('n', '<Leader>o', '<Cmd>only<CR>', {}) -- 分割画面を一つにする
map('n', '<Leader>cl', '<Cmd>close<CR>', {}) -- 今の画面を閉じる

