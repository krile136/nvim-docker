return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { "lua", "go", "php" },
      highlight = {
        enable = true,
		    indent = {
				  enable = true,
		    },
        additional_vim_regex_highlighting = true,  -- phpのparserを入れるとインデントが効かなくなるがこのオプションで有効になるらしい
      }
    })
  end
}
