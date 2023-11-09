return {
  'yuchanns/phpfmt.nvim',
  config = function()
    require("phpfmt").setup({
      standard = "PSR2",
      auto_format = true,
    })
  end
}
