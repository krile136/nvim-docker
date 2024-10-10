return {
  'nvim-lualine/lualine.nvim',
  config = function()
-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
    local colors = {
      blue   = '#80a0ff',
      cyan   = '#79dac8',
      black  = '#080808',
      white  = '#c6c6c6',
      red    = '#ff5189',
      violet = '#d183e8',
      grey   = '#303030',
    }


    local bubbles_theme = {
      normal = {
        a = { fg = colors.black, bg = colors.violet },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.black, bg = colors.black },
        x = { fg = colors.black, bg = colors.black },
        y = { fg = colors.white, bg = colors.grey },
        z = { fg = colors.black, bg = colors.violet },
      },

      insert = { a = { fg = colors.black, bg = colors.blue }, z = { fg = colors.black, bg = colors.blue } },
      visual = { a = { fg = colors.black, bg = colors.cyan }, z = { fg = colors.black, bg = colors.cyan } },
      replace = { a = { fg = colors.black, bg = colors.red }, z = { fg = colors.black, bg = colors.red }  },
  
      inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.black, bg = colors.black },
      },
    }

    local function lsp_clients()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      local noClients = "%#LspIcon#%#LspText#  no LSP clinet"
      if next(clients) == nil then
        return noClients 
      end
      local client_names = {}
      for _, client in pairs(clients) do
        if client.name ~= "copilot" then
          table.insert(client_names, client.name)
        end
      end
      
      if next(client_names) == nil then return noClients end
      return "%#LspIcon#%#LspText#  " .. table.concat(client_names, ", ")
    end

    local function current_time()
      return "%#TimeIcon#%#TimeText# " .. os.date("%H:%M:%S")
    end

    require('lualine').setup {
      options = {
        theme = bubbles_theme,
        component_separators = '|',
      },
  
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'filename', 'branch','encoding'},
        lualine_c = { 'diagnostics' },
        lualine_x = { 'diff' },
        lualine_y = { 
          {'copilot',
            symbols = {
                status = {
                    icons = {
                        enabled = " ",
                        sleep = " ",   -- auto-trigger disabled
                        disabled = " ",
                        warning = " ",
                        unknown = " "
                    },
                    hl = {
                        enabled = "#50FA7B",
                        sleep = "#50FA7B",
                        disabled = "#6272A4",
                        warning = "#FFB86C",
                        unknown = "#FF5555"
                    }
                },
                spinners = require("copilot-lualine.spinners").dots,
                spinner_color = "#EE7800"
            },
            show_colors = true},
          {'filetype'},
          {lsp_clients, color = {fg = colors.white, bg = colors.grey} },
          {current_time, color = {fg = colors.white, bg = colors.grey} },
        },
        lualine_z = { 
          'location'
        } 
      },
  
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    }
  end
}
