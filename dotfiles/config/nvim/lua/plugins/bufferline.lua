return {
    'akinsho/bufferline.nvim', 
    version = "*", 
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    option = function()
      vim.opt.termguicolors = true
      require("bufferline").setup({})
    end
  }
