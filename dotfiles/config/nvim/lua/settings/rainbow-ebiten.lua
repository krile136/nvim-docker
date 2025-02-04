
local namespace_id = vim.api.nvim_create_namespace("RainbowEbiten")

local query_string = [[
  (identifier) @variable
]]

local colors = {
  "#FF0000",
  "#FF6600",
  "#FFFF00",
  "#00FF00",
  "#00FFFF", 
  "#0000FF",
  "#800080",
}

-- colorsのindex毎にハイライトグループを作成
for i, color in ipairs(colors) do
  local hl_group = "RainbowEbiten" .. i
  vim.cmd("highlight default " .. hl_group .. " guifg=" .. color)
end

-- 現在のバッファのハイライトをクリアする関数
local function clear_highlights()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, namespace_id, 0, -1)
end

local count = 0;

local function rainbowEbiten()

  -- 現在のバッファのファイルタイプを取得
  local filetype = vim.bo.filetype
  if(filetype ~= "go") then
    return
  end

  clear_highlights()

    -- 現在のバッファのツリーパーサーを取得
  local parser = vim.treesitter.get_parser(0)
  local tree = parser:parse()[1]

  -- ルートノードを取得
  local root = tree:root()

  -- 文字列ノードを抽出するクエリ
  local query = vim.treesitter.query.parse(filetype, query_string)

  -- 現在のバッファのバッファ番号を取得
  local bufnr = vim.api.nvim_get_current_buf()

  for id, node in query:iter_captures(root, 0, 0, -1) do
    local text = vim.treesitter.get_node_text(node, 0)
    if(string.find(text, "ebiten", 1, true)) then
      local color_index = count % #colors + 1
      local hl_group = "RainbowEbiten" .. color_index
      local start_row, start_col, end_row, end_col = node:range()

      vim.api.nvim_buf_add_highlight(0, namespace_id, hl_group, start_row, start_col, end_col)
    end
  end

  count = count + 1
end

-- タイマーを作成
local timer = vim.loop.new_timer()

-- 毎フレーム（16.67msごとに）rainbowEbiten関数を呼び出す
timer:start(0, 32, vim.schedule_wrap(function()
  rainbowEbiten()
end))

-- Neovimが終了する際にタイマーを停止
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    timer:stop()
    timer:close()
  end,
})

