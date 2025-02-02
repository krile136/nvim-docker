local ts_utils = require 'nvim-treesitter.ts_utils'

local namespace_id = vim.api.nvim_create_namespace("TestMessageColorNamespace")

local queries = {
  apex = [[
    (string_literal) @string_literal
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

local function analyze_test_message()
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
