return {
  'mvllow/modes.nvim',
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

	end
}
