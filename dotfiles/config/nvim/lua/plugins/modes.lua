return {
  'mvllow/modes.nvim',
  event = 'VimEnter', -- Neovimの起動が完了した後にロード
  tag = 'v0.2.0',
  config = function()
    require('modes').setup()

    -- ecsでノーマルモードに戻った時は正常に戻るが、
    -- control + s でノーマルモードに戻った時に反応しないので
    -- ノーマルモードの時に強制的にリセットをさせる
    vim.api.nvim_create_autocmd('ModeChanged', {
      pattern = '*:n',
      callback = function()
        require('modes').reset()
      end,
    })

    -- 定義ジャンプ後にvキーがなぜか入力されてnoramモードなのに
    -- visualモードの色になっているので、カーソル移動後にnormalなら
    -- 強制的にdefaultに戻す
    vim.api.nvim_create_autocmd('CursorMoved', {
      callback = function()
        if vim.fn.mode() == 'n' then
          require('modes').highlight('default')
        end
      end,
    })
  end
}
