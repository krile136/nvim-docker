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
      }
    }
  )
  end
}
