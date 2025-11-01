-- 色のリスト
local colors = {
-- 鮮やかな基本色 (Vibrant Basics)
  { fg = "#FF6F61" }, -- 1. Coral (コーラルレッド)
  { fg = "#F67C1B" }, -- 2. Bright Orange (明るいオレンジ)
  { fg = "#E5D180" }, -- 3. Mellow Yellow (黄)
  { fg = "#35D27F" }, -- 4. Bright Green (明るい緑)
  { fg = "#2AAA8A" }, -- 5. Teal (ティール/青緑)
  { fg = "#61AFEF" }, -- 6. Bright Blue (明るい青)
  { fg = "#C678DD" }, -- 7. Bright Purple (明るい紫)
  { fg = "#EB75D6" }, -- 8. Bright Pink (明るいピンク)

  -- 落ち着いた中間色 (Muted Mid-tones)
  { fg = "#E06C75" }, -- 9. Soft Red (ソフトな赤)
  { fg = "#ef9062" }, -- 10. Soft Orange (ソフトなオレンジ)
  { fg = "#D19A66" }, -- 11. Brownish (茶色系)
  { fg = "#88B04B" }, -- 12. Olive (オリーブ)
  { fg = "#56B6C2" }, -- 13. Cyan (シアン)
  { fg = "#8997F5" }, -- 14. Periwinkle (ペリウィンクル/青紫)
  { fg = "#C3447A" }, -- 15. Maroon (マルーン/暗めの赤紫)
  { fg = "#D49DA5" }, -- 16. Dusty Rose (くすんだピンク)

  -- 明るいアクセント色 (Bright Accents)
  { fg = "#F6B223" }, -- 17. Gold (ゴールド)
  { fg = "#BBEA87" }, -- 18. Lime (ライムグリーン)
  { fg = "#80FFEA" }, -- 19. Aqua (アクア)
  { fg = "#96CDFB" }, -- 20. Sky Blue (スカイブルー)
  { fg = "#DDB6F2" }, -- 21. Lavender (ラベンダー)
  { fg = "#F28FAD" }, -- 22. Rosewater (ローズウォーター)
  { fg = "#F8BD96" }, -- 23. Peach (ピーチ)
  { fg = "#ABE9B3" }, -- 24. Mint (ミント)}
}

-- 初期化を走らせたくないファイルタイプを管理するテーブル
local ignore_initialize_filetypes = { "TelescopePrompt", "oil" }

-- 無視する変数名を管理するテーブル
local ignore_variables = {}

-- 変数名ごとに色を管理するテーブル
local variable_colors = {}
local color_index = 1

-- 名前空間IDを作成
local namespace_id = vim.api.nvim_create_namespace("VariableColorNamespace")

-- ファイルタイプごとのクエリを定義するテーブル
-- variable_queryで広く取りつつ、ignore_queryで無視するノードを細かく指定する
-- それでも色がついてしまうnodeについてはignore_special_conditionsでさらに細かく無視する条件を指定する
local queries = {
  apex = {
    as = "apex",
    ignore_query = [[
    ]],
    ignore_special_conditions = function(node)
      local var_name = vim.treesitter.get_node_text(node, 0)
       -- var_nameの先頭が大文字かどうかを判定
       if var_name:sub(1, 1):match("%u") then
         return true
       end
       return false
    end,
    variable_query = [[
      (variable_declarator
        (identifier) @variable
      )
      (formal_parameter
        (identifier) @variable
      )
      (field_access
        (identifier) @variable
      )
      (assignment_expression
        (identifier) @variable
      )
      (binary_expression
        (identifier) @variable
      )
      (method_invocation
        (identifier) @variable
        "."
        (identifier)
      )
      (argument_list
        (identifier) @variable
      )
      (parenthesized_expression
        (identifier) @variable
      )
      (return_statement
        (identifier) @variable
      )
      (enhanced_for_statement
        (identifier) @variable
      )
      (update_expression
        (identifier) @variable
      )
      (array_initializer
        (identifier) @variable
      )
      (array_access
        (identifier) @variable
      )
      (catch_formal_parameter
        (identifier) @variable
      )
      (bound_apex_expression
        (identifier) @variable
      )
      (map_initializer
        (identifier) @variable
      )
      (dml_expression
        (identifier) @variable
      )
      (unary_expression
        (identifier) @variable
      )
      (cast_expression
        (identifier) @variable
      )
    ]],
  },
  go = {
    as ="go",
    ignore_query = "",
    ignore_special_conditions = function(node)
      return false;
    end,
    variable_query = [[
      (expression_list
        (identifier) @variable
      )
    ]],
  },
  php = {
    as = "php",
    ignore_query = "",
    ignore_special_conditions = function(node)
      return false;
    end,
    variable_query = [[
      (variable_name (name) @variable)
      (member_access_expression (name) @variable)
    ]]
  },
  typescript = {
    as="typescript",
    ignore_query = [[
      (function_declaration name: (identifier) @function.name)
      (call_expression 
        function: (member_expression
          property: (property_identifier) @method.call
        )
      )
    ]],
    ignore_special_conditions = function(node)
      local var_name = vim.treesitter.get_node_text(node, 0)
       -- var_nameの先頭が大文字かどうかを判定
       if var_name:sub(1, 1):match("%u") then
         return true
       end
       return false

    end,
    variable_query = [[
      (identifier) @variable
      (shorthand_property_identifier_pattern) @variable
      (property_identifier) @variable
    ]]
  },
  typescriptreact = {
    as="tsx",
    ignore_query = [[
    ]],
    ignore_special_conditions = function(node)
      local var_name = vim.treesitter.get_node_text(node, 0)
      -- var_nameに()が含まれているかどうかを判定
      if var_name:match("%b()") then
        return true
      end
      return false
    end,
    variable_query = [[
      (import_specifier
        (identifier) @variable
      )
      (variable_declarator
        (identifier) @variable
      )
      (property_signature
        (property_identifier) @variable
      )
      (required_parameter
        (identifier) @variable
      )
      (member_expression
        (identifier) @variable
      )
      (property_identifier) @variable
      (arguments
        (identifier) @variable
      )
      (shorthand_property_identifier_pattern) @variable
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
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'c' then
    return
  end

  local buffers = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(buffers) do
    vim.api.nvim_buf_clear_namespace(bufnr, namespace_id, 0, -1)
  end
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
local function analyze_buffer()
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'c' then
    return
  end

  -- 現在のバッファのファイルタイプを取得
  local filetype = vim.bo.filetype

  -- 対応するファイルタイプの場合のみ実行
  if queries[filetype] then
    treesitter_filetype = queries[filetype].as

    -- 現在のバッファのツリーパーサーを取得
    local parser = vim.treesitter.get_parser(0)
    local tree = parser:parse()[1]

    -- ルートノードを取得
    local root = tree:root()

    -- 無視するノードを抽出するクエリ
    local ignore_query_string = queries[filetype].ignore_query

    local query = vim.treesitter.query.parse(treesitter_filetype, ignore_query_string)

    -- 無視するノードを実行して、無視する変数リストを作成
    for id, node in query:iter_captures(root, 0, 0, -1) do
      local name = query.captures[id]
      local var_name = vim.treesitter.get_node_text(node, 0)
      if type(var_name) == "table" then
        var_name = table.concat(var_name, "\n")
      end
      ignore_variables[var_name] = true
    end

    -- 変数ノードを抽出するクエリ
    local query_string = queries[filetype].variable_query

    query = vim.treesitter.query.parse(treesitter_filetype, query_string)

    -- クエリを実行して変数ノードを取得
    for id, node in query:iter_captures(root, 0, 0, -1) do
      local name = query.captures[id] -- クエリのキャプチャ名
      local var_name = vim.treesitter.get_node_text(node, 0)
      if type(var_name) == "table" then
        var_name = table.concat(var_name, "\n")
      end

      if contains_special_characters(var_name)
        or ignore_variables[var_name]
        or queries[filetype].ignore_special_conditions(node)
      then
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

local function initialize()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo.filetype
  -- 無視するファイルタイプ
  if vim.tbl_contains(ignore_initialize_filetypes, filetype) then
    return
  end
  clear_highlights()
  analyze_buffer()
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter", "TextChanged", "InsertLeave" }, {
  callback = analyze_buffer,
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
  initialize()
end, {})

vim.api.nvim_create_user_command('PrintTree', function()
  local parser = vim.treesitter.get_parser(0)
  local tree = parser:parse()[1]
  local root = tree:root()
  print_tree(root)
end, {})


map('n', '<Leader>r', '<Cmd>ResetSemanticHighlights<CR>', { noremap = true })
