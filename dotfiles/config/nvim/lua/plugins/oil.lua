vim.cmd [[
  highlight CustomLightBlue guifg=#ADD8E6
]]

return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  config = function()
    map('n', '<Leader>e', ':Oil<CR>', { noremap = true })

    require('oil').setup({
      win_options = {
        signcolumn = "yes:2",
      },
      keymaps = {
        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
          -- 名前に"cls-meta" が含まれるファイルは非表示
          if name:match("cls%-meta") then
            return true
          end
          return false
        end,
        -- Customize the highlight group for the file name
        highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
        end,
      }
    })
  end,
}
