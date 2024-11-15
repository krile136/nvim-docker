return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  config = function()
    map('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true })
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
        highlight_git = true,
        icons = {
          glyphs = {
            git = {
              unstaged = '!',
              renamed = '»',
              untracked = '?',
              deleted = '✘',
              staged = '✓',
              unmerged = '',
              ignored = '◌',
            },
          },
        },
      },
      git = {
        enable = true,
        ignore = false,
      },
      filters = {
        dotfiles = false,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      }
    })
  end
}
