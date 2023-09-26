return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  config = function()
    map('n', '<Leader>e', ':NvimTreeToggle<CR>', {noremap=true})
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
      },
      sort_by = "case_sensitive",
      view = {
        width = 60,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
      actions = {
        open_file = {
         quit_on_open = true,
         },
      }
    })
  end
}
