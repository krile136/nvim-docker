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
    map('n', '<Leader>e', '<Cmd>Oil<CR>', { noremap = true })

    -- Toggle function
    vim.api.nvim_create_user_command("OilToggleClsMeta", function()
      show_cls_meta = not show_cls_meta
      vim.notify("Show cls-meta: " .. tostring(show_cls_meta))
      -- Reload Oil buffer if open
      local oil = require("oil")
      if oil.get_current_dir() then
        oil.open(oil.get_current_dir())
      end
    end, {})


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
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
          if not show_cls_meta and name:match("cls%-meta") then
            return true
          end
          return false
        end,
        highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
        end,
      }
    })
  end,
}
