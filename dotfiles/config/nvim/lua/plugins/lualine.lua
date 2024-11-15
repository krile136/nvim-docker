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
      darkGrey = '#7d7d7d'
    }


    local bubbles_theme = {
      normal = {
        a = { fg = colors.black, bg = colors.violet },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.darkGrey, bg = colors.black },
        x = { fg = colors.white, bg = colors.black },
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

    -- LSPクライアントを表示する
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

    -- 現在時刻をアイコンと一緒に表示する
    local function current_time()
      return "%#TimeIcon# %#TimeText# " .. os.date("%H:%M:%S")
    end


    -- ブランチ名を表示する
    -- masterとmainに対して警告を出したいのでカスタム関数を使用
    -- 取得間隔を開けないとカーソルがちらつくのでキャッシュを使用
    local cached_branch = nil
    local last_check_time = 0
    local cache_duration = 5000 -- キャッシュの有効期間（ミリ秒）
    local function branch_with_icon()
      local current_time = vim.loop.now()

      if not cached_branch or (current_time - last_check_time > cache_duration) then
        cached_branch = vim.fn.system('git branch --show-current'):gsub('%s+', '')
        last_check_time = current_time
      end

      if cached_branch:find('fatal') then
        return '%#GitIcon#?%#GitText# Branch not found'
      elseif cached_branch == 'main' or cached_branch == 'master' then
        return '⚠️   ' .. cached_branch
      else
        return '%#GitIcon#%#GitText# ' .. cached_branch
      end
    end

    -- encodingを色付きのアイコンと一緒に表示する
    local function encoding_with_icon()
      local encoding = vim.bo.fileencoding
      if encoding == '' then
        encoding = vim.o.encoding
      end
      return '%#EncodingIcon# %#EncodingText# ' .. encoding
    end



    require('lualine').setup {
      options = {
        theme = bubbles_theme,
        component_separators = '|',
      },
  
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {},
        lualine_c = { {'filename', path = 1}},
        lualine_x = { 'diagnostics', 'diff' },
        lualine_y = { 
          {'filetype'},
          {lsp_clients, color = {fg = colors.white, bg = colors.grey} },
          {branch_with_icon, color = {fg = colors.white, bg = colors.grey}},
          {encoding_with_icon, color = {fg = colors.white, bg = colors.grey}},
          {current_time, color = {fg = colors.white, bg = colors.grey} },
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
