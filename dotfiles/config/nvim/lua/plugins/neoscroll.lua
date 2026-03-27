return {
  'karb94/neoscroll.nvim',
  config = function()
    -- EnableHLIndentを1秒後に実行するためのタイマーオブジェクトを保持する変数
    local indent_timer = nil

    require("neoscroll").setup({
      -- スクロール開始前のフック
      pre_hook = function()
        -- スクロール中はスクロールバーがおかしくなるので非表示にする
        vim.cmd("ScrollbarHide")

        -- もし1秒以内に次のスクロールが始まったら、
        -- 待機中のEnableHLIndentタイマーをキャンセルする
        if indent_timer then
          indent_timer:stop()
          indent_timer:close() -- タイマーハンドルを閉じる
          indent_timer = nil
        end

        -- パフォーマンスに影響するプラグインを無効化
        vim.cmd("DisableHLChunk")
        vim.cmd("DisableHLIndent")
      end,

      -- スクロール終了後のフック
      post_hook = function()
        -- スクロールバーを再表示
        vim.cmd("ScrollbarShow")

        -- HLChunkは即時有効化
        vim.cmd("EnableHLChunk")

        -- HLIndentは1秒後に有効化するためのタイマーを作成して開始
        indent_timer = vim.loop.new_timer()
        indent_timer:start(
          500, -- 遅延時間 (ms)
          0,    -- 繰り返し間隔 (0 = 繰り返さない)
          -- 実行するコールバック関数
          vim.schedule_wrap(function()
            vim.cmd("EnableHLIndent")
          end)
        )
      end,
    })

    -- キーマップの設定
    local keymap = {
      ["<C-u>"] = function() require('neoscroll').ctrl_u({ duration = 100, easing = 'sine' }) end,
      ["<C-d>"] = function() require('neoscroll').ctrl_d({ duration = 100, easing = 'sine' }) end,
    }
    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end
}
