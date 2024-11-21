local ts_utils = require 'nvim-treesitter.ts_utils'

-- 色のリスト
local colors = {
  { fg = "#ef9062" },
  { fg = "#3AC6BE" },
  { fg = "#35D27F" },
  { fg = "#EB75D6" },
  { fg = "#E5D180" },
  { fg = "#8997F5" },
  { fg = "#D49DA5" },
  { fg = "#7FEC35" },
  { fg = "#F6B223" },
  { fg = "#F67C1B" },
  { fg = "#BBEA87" },
  { fg = "#FF6F61" },
  { fg = "#88B04B" },
  { fg = "#F7CAC9" },
  { fg = "#C3447A" },
}

-- 無視する変数名を管理するテーブル
local ignore_variables = {}

-- 変数名ごとに色を管理するテーブル
local variable_colors = {}
local color_index = 1

-- 名前空間IDを作成
local namespace_id = vim.api.nvim_create_namespace("VariableColorNamespace")

-- ファイルタイプごとのクエリを定義するテーブル
local queries = {
  apex = {
    ignore_query = [[
      (method_declaration name: (identifier) @function.method)
    ]],
    variable_query = [[
      (identifier) @variable
    ]]
  },
  go = {
    ignore_query = "",
    variable_query = [[
      (identifier) @variable
    ]]
  },
  php = {
    ignore_query = "",
    variable_query = [[
      (variable_name (name) @variable)
    ]]
  },
  typescript = {
    ignore_query = [[
      (function_declaration name: (identifier) @function.name)
    ]],
    variable_query = [[
      (identifier) @variable
      (shorthand_property_identifier_pattern) @variable
      (property_identifier) @variable
    ]]
  }
}

-- ツリー全体を出力する関数
local function print_tree(node, indent)
  indent = indent or ""
  print(indent .. node:type())
  for child in node:iter_children() do
    print_tree(child, indent .. "  ")
  end
end

-- 既存のハイライトグループを削除する関数
local function clear_highlights()
  vim.api.nvim_buf_clear_namespace(0, namespace_id, 0, -1)
  variable_colors = {}
  color_index = 1
end

-- 英数字以外が含まれているかどうかを確認する関数
local function contains_special_characters(str)
  -- 英数字およびアンダースコア以外の文字が含まれているかをチェック
  return not str:match("^[%w_]+$")
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


-- tree-sitterのnodeを解析して変数をハイライトする

-- tree-sitterのnodeを解析して変数をハイライトする
local function analyze_buffer()
  -- 現在のバッファのファイルタイプを取得
  local filetype = vim.bo.filetype

  -- 対応するファイルタイプの場合のみ実行
  if queries[filetype] then
    -- 現在のバッファのツリーパーサーを取得
    local parser = vim.treesitter.get_parser(0)
    local tree = parser:parse()[1]

    -- ルートノードを取得
    local root = tree:root()


    -- 無視するノードを抽出するクエリ
    local ignore_query_string = queries[filetype].ignore_query

    local query = vim.treesitter.query.parse(filetype, ignore_query_string)

    -- 無視するノードを実行して、無視する変数リストを作成
    for id, node in query:iter_captures(root, 0, 0, -1) do
      local name = query.captures[id]
      local var_name = vim.treesitter.get_node_text(node, 0)
      print(var_name)
      if type(var_name) == "table" then
        var_name = table.concat(var_name, "\n")
      end
      ignore_variables[var_name] = true
    end

    -- 変数ノードを抽出するクエリ
    local query_string = queries[filetype].variable_query

    query = vim.treesitter.query.parse(filetype, query_string)

    -- クエリを実行して変数ノードを取得
    for id, node in query:iter_captures(root, 0, 0, -1) do
      local name = query.captures[id] -- クエリのキャプチャ名
      if name == "variable" then
        local var_name = vim.treesitter.get_node_text(node, 0)
        if type(var_name) == "table" then
          var_name = table.concat(var_name, "\n")
        end

        if contains_special_characters(var_name) then
          -- 英数字以外だとハイライトグループ設定時にエラーになるので無視させる
          goto continue
        end
        if (ignore_variables[var_name]) then
          goto continue
        end

        local hl_group = "VariableColor" .. var_name
        -- 変数に色を割り当てる
        if not variable_colors[var_name] then
          variable_colors[var_name] = colors[color_index]
          color_index = color_index % #colors + 1
          -- ハイライトグループを作成
          vim.api.nvim_set_hl(0, hl_group, variable_colors[var_name])
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local start_row, start_col, end_row, end_col = node:range()
        local is_highlighted = has_highlight(bufnr, namespace_id, hl_group, start_row, start_col, end_row, end_col)

        if not is_highlighted then
          -- 変数にハイライトを適用
          vim.api.nvim_buf_add_highlight(bufnr, namespace_id, hl_group, start_row, start_col, end_col)
        end

        ::continue::
      end
    end
  end
end

local function initialize()
  clear_highlights()
  analyze_buffer()
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
  callback = analyze_buffer,
})

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
  callback = initialize,
})

-- TextChangedIイベントが発火したときにスペースが入力されたかどうかをチェックする関数
local function on_text_changed_i()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col('.') - 1
  if col > 0 and line:sub(col, col) == ' ' then
    analyze_buffer()
  end
end

vim.api.nvim_create_autocmd("TextChangedI", {
  callback = on_text_changed_i,
})

-- Resetコマンドを作成
vim.api.nvim_create_user_command('ResetSemanticHighlights', function()
  clear_highlights()
  analyze_buffer()
end, {})

vim.api.nvim_create_user_command('PrintTree', function()
  local parser = vim.treesitter.get_parser(0)
  local tree = parser:parse()[1]
  local root = tree:root()
  print_tree(root)
end, {})


map('n', '<Leader>r', ':ResetSemanticHighlights<CR>', { noremap = true })
