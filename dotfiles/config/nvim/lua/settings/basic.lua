--------------------- options ---------------------
local options = {
  number = true,                             -- 行番号を表示
  confirm = true,                            -- ファイル保存をしていないのに閉じようとしたときに確認がはいる
  hidden = true,                             -- bufferを切り替えるときに編集中ファイルを保存しなくても良くなる
  scrolloff = 10,                            -- スクロールするときにマージンを10行分取っておく
  encoding = "utf-8",                        ---- ファイルを開いたときのデフォルトエンコードをutf-8にする
  clipboard = vim.opt.clipboard + 'unnamed', -- クリップボードを使用できるようにする
  backspace = 'indent,eol,start',            -- バックスペースで削除できるようにする
  title = true,                              -- ファイル名を表示する
  ignorecase = true,                         -- 検索時に大文字と小文字の区別をなくす
  smartcase = true,                          -- ignorecaseとの組み合わせで検索パターンに大文字を含むときだけ大文字・小文字を区別して検索
  hlsearch = true,                           -- 検索結果をハイライト
  incsearch = true,                          -- インクリメンタルサーチを有効にする
  inccomand = split,                         -- 置換のときにインタラクティブに変更できる
  expandtab = true,                          -- タブをスペースにする
  shiftwidth = 2,                            -- タブを増やしたり減らしたりするときの文字数
  tabstop = 2,                               -- タブを2文字分にする(defaultは8)
  softtabstop = 0,                           -- インサートモード時に、<Tab>キー、<BS>キーの入力に対する見た目上の空白数を設定する(効果がよくわからん、要検証)
  smarttab = true,                           -- 行の先頭で<Tab>キーを入力するとインデントを挿入する
  shiftwidth = 2,                            -- `>>`シフトコマンドなどで行頭に挿入するスペースの数
  shiftround = true,                         -- `>>` シフトコマンドなどを実行すると行の先頭にshiftwidthの分だけスペースが挿入される
  laststatus = 3,                            -- lualineのglobalstatusと組み合わせると、画面をsplitしてもステータスバーが一つに維持される
}

for k, v in pairs(options) do
  vim.opt[k] = v
end


--------------------- global ---------------------
local global = {
  mnowrapscan = true, -- 検索が最下部で止まる（ファイルの先頭に戻らない）
  mapleader = " ",    -- leaderキーをスペースにする
  lsp_log_file = "",  -- lspのログ出力をOFFにする (lsp_log_verboseとセット)   これをやらないとlspの補完や参照がとても重い
  lsp_log_verbose = 1,
}

for k, v in pairs(global) do
  vim.g[k] = v
end


--------------------- windowOption ---------------------
local windowOption = {
  wrap = false, -- 画面端で折り返さない
}

for k, v in pairs(windowOption) do
  vim.wo[k] = v
end


--------------------- yank highlighting ---------------------
vim.api.nvim_exec([[
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}
augroup END
]], false)
