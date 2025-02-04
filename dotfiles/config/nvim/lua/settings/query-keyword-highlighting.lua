local ts_utils = require 'nvim-treesitter.ts_utils'

local namespace_id = vim.api.nvim_create_namespace("TestMessageColorNamespace")

local queries = {
  apex = [[
    (string_literal) @string_literal
    (modifier) @modifier
  ]],
  go = [[
  ]],
}

local triggerSetting = {
  normal = {
    color = { fg="#000000", bg = "#90EE90"},  -- LightGreen
    keyword = "正常系",
  },
  abnormal = {
    color = { fg="#000000", bg = "#FFB6C1"},  -- LightPink
    keyword = "異常系",
  },
  edge = {
    color = { fg ="#000000", bg = "#F0E68C"},  -- Khaki
    keyword = "エッジケース",
  },
  testMethod = {
    color = { fg="#000000", bg = "#87CEFA"},  -- LightSkyBlue
    keyword = "testMethod",
  }
}

-- triggerSetting毎にハイライトグループを登録
for key, setting in pairs(triggerSetting) do
  local hl_group = "TestMessageColorNamespace" .. key
  vim.api.nvim_set_hl(0, hl_group, setting.color)
end

local function get_include_trigger_key(text)
  for key, setting in pairs(triggerSetting) do
    if string.find(text, setting.keyword, 1, true) then
      return key
    end
  end
  return nil
end

-- 特定のハイライトグループが当たっているかどうかを確認する関数
local function has_highlight(bufnr, namespace_id, hl_group, start_row, start_col, end_row, end_col)
  -- バッファ内のすべての拡張マークを取得
  local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, namespace_id, { start_row, start_col }, { end_row, end_col },
    { details = true })
  for _, extmark in ipairs(extmarks) do
    -- 拡張マークのハイライトグループが一致する場合にtrueを返す
    if extmark[4].hl_group == hl_group then
      return true
    end
  end
  return false
end

-- 現在のバッファのハイライトをクリアする関数
local function clear_highlights()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, namespace_id, 0, -1)
end


local function analyze_test_message()
  clear_highlights()

  -- 現在のバッファのファイルタイプを取得
  local filetype = vim.bo.filetype

  -- 対応するファイルタイプの場合のみ実行
  local query_string = queries[filetype]
  if not query_string then
    return
  end

  -- 現在のバッファのツリーパーサーを取得
  local parser = vim.treesitter.get_parser(0)
  local tree = parser:parse()[1]

  -- ルートノードを取得
  local root = tree:root()

  -- 文字列ノードを抽出するクエリ
  local query = vim.treesitter.query.parse(filetype, query_string)

  -- 現在のバッファのバッファ番号を取得
  local bufnr = vim.api.nvim_get_current_buf()

  -- クエリを実行して文字列ノードを取得
  for id, node in query:iter_captures(root, 0, 0, -1) do
    local text = vim.treesitter.get_node_text(node, 0)
    local key = get_include_trigger_key(text)

    if key then
      local hl_group = "TestMessageColorNamespace" .. key
      local start_row, start_col, end_row, end_col = node:range()

      vim.api.nvim_buf_add_highlight(0, namespace_id, hl_group, start_row, start_col, end_col)
    end
  end
end


vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter", "TextChanged", "InsertLeave" }, {
  callback = analyze_test_message,
})
