return {
  'nvim-lualine/lualine.nvim',
  config = function()
    -- Bubbles config for lualine
    -- Author: lokesh-krishna
    -- MIT license, see LICENSE for more details.

    -- stylua: ignore
    local colors = {
      blue     = '#80a0ff',
      cyan     = '#79dac8',
      black    = '#080808',
      white    = '#c6c6c6',
      red      = '#ff5189',
      violet   = '#d183e8',
      grey     = '#303030',
      darkGrey = '#A9A9A9',
    }

    local bubbles_theme = {
      normal = {
        a = { fg = colors.black, bg = colors.violet },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.whitey, bg = colors.black },
        x = { fg = colors.white, bg = colors.black },
        y = { fg = colors.white, bg = colors.grey },
        z = { fg = colors.black, bg = colors.violet },
      },

      insert = { a = { fg = colors.black, bg = colors.blue }, z = { fg = colors.black, bg = colors.blue } },
      visual = { a = { fg = colors.black, bg = colors.cyan }, z = { fg = colors.black, bg = colors.cyan } },
      replace = { a = { fg = colors.black, bg = colors.red }, z = { fg = colors.black, bg = colors.red } },

      inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.black, bg = colors.black },
      },
    }

    -- LSPクライアントを表示する
    local function lsp_clients()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      local noClients = "%#LspIcon#%#StatusText#  no LSP clinet"
      if next(clients) == nil then
        return noClients
      end
      local client_names = {}
      for _, client in pairs(clients) do
        if client.name ~= "copilot" and client.name ~= "null-ls" then
          table.insert(client_names, client.name)
        end
      end

      if next(client_names) == nil then return noClients end
      return "%#LspIcon#%#StatusText#  " .. table.concat(client_names, ", ")
    end

    -- 現在時刻をアイコンと一緒に表示する
    local function current_time()
      return "%#TimeIcon# %#StatusText# " .. os.date("%H:%M:%S")
    end

    local function current_date()
      return "%#DateIcon# %#StatusText# " .. os.date("%m/%d(%a)")
    end

    -- ブランチ名を表示する
    -- masterとmainに対して警告を出したいのでカスタム関数を使用
    -- 取得間隔を開けないとカーソルがちらつくのでキャッシュを使用
    local cached_branch = nil
    local last_check_time = 0
    local cache_duration = 5000 -- キャッシュの有効期間（ミリ秒）
    local function branch_with_icon()
      local now = vim.loop.now()

      if not cached_branch or (now - last_check_time > cache_duration) then
        cached_branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('%s+', '')
        last_check_time = now
      end

      if cached_branch:find('fatal') then
        return '%#GitIcon#?%#StatusText# Branch not found'
      elseif cached_branch == 'main' or cached_branch == 'master' then
        return '%#GitAlertIcon#%#StatusText#  ' .. cached_branch
      else
        return '%#GitIcon#%#StatusText# ' .. cached_branch
      end
    end

    -- encodingを色付きのアイコンと一緒に表示する
    local function encoding_with_icon()
      local encoding = vim.bo.fileencoding
      if encoding == '' then
        encoding = vim.o.encoding
      end
      return '%#EncodingIcon# %#StatusText# ' .. encoding
    end

    -- バッテリーの残量を表示する
    local cached_battery_status = "N/A"
    local last_battery_check_time = 0
    local battery_cache_duration = 20000 -- キャッシュの有効期間（ミリ秒）
    local function battery_status()
      local now = vim.loop.now()
      if not cached_battery_status or (now - last_battery_check_time > battery_cache_duration) then
        local file, err = io.open("/root/batteryStatus.txt", "r")
        if file then
          cached_battery_status = file:read("*all"):gsub("%s+", "")
          file:close()
        else
          print("Error reading battery status: " .. err)
          cached_battery_status = "N/A"
        end
        last_battery_check_time = now
      end

      local battery_message = "%#"
      if (cached_battery_status == "N/A") then
        battery_message = battery_message .. "BatteryNoneIcon#󰂑%#StatusText# "
      else
        -- Split the cached_battery_status by comma
        local battery_level, battery_resource = cached_battery_status:match("([^,]+),%s*(.+)")
        -- print("battery resource: " .. battery_resource)
        if string.find(battery_resource, "AC") then
          battery_message = battery_message .. "BatteryChargingIcon#󰚥 %#"
        end
        local battery_number = tonumber(battery_level)
        if (battery_number < 20) then
          battery_message = battery_message .. "BatteryDangerIcon#󱊡"
        elseif (battery_number < 50) then
          battery_message = battery_message .. "BatteryWarningIcon#󱊢"
        elseif (battery_number < 99) then
          battery_message = battery_message .. "BatteryGoodIcon#󱊣"
        else
          battery_message = battery_message .. "BatteryFullIcon#󱊣"
        end
        battery_message = battery_message .. "%#StatusText# " .. battery_level .. "%%"
      end

      return battery_message
    end

    local cached_calendar_event = ""
    local last_calendar_check_time = 0
    local calendar_cache_duration = 20000 -- キャッシュの有効期間（ミリ秒）

    local function next_calendar_event()
      local now = vim.loop.now()
      local mode = vim.api.nvim_get_mode().mode
      if mode == 'v' or mode == 'V' or mode == '\22' then
        return ""
      end

      if not cached_calendar_event or (now - last_calendar_check_time > calendar_cache_duration) then
        local file, err = io.open("/root/calendar_lualine.txt", "r")
        if not file then
          cached_calendar_event = ""
        else
          local date_now = os.date("*t")
          local current_minutes = date_now.hour * 60 + date_now.min
          local next_event = nil
          local next_start_minutes = nil

          for line in file:lines() do
            local title, time_str, place = line:match("([^,]+),([^,]+),(.+)")
            if title and time_str and place then
              title = title:gsub("%s*%b()", "")
              local start_h, start_m, end_h, end_m = time_str:match("today at (%d+):(%d+) %- (%d+):(%d+)")
              if start_h and start_m and end_h and end_m then
                local start_minutes = tonumber(start_h) * 60 + tonumber(start_m)
                if start_minutes >= current_minutes then
                  if not next_start_minutes or start_minutes < next_start_minutes then
                    next_start_minutes = start_minutes
                    local places = {}
                    for p in place:gmatch("[^;]+") do
                      if not p:find("Microsoft") then
                        table.insert(places, vim.trim(p))
                      end
                    end
                    local place_str = table.concat(places, "; ")
                    next_event = {
                      title = title,
                      time = string.format("%s:%s - %s:%s", start_h, start_m, end_h, end_m),
                      place = place_str
                    }
                  end
                end
              end
            end
          end
          file:close()
          if next_event then
            cached_calendar_event = string.format("%s | %s | %s | %s", current_date(), next_event.title, next_event.time, next_event.place)
          else
            cached_calendar_event = "本日の次の予定はありません"
          end
        end
        last_calendar_check_time = now
      end

      return cached_calendar_event
    end

    -- 選択範囲の行数と文字数を表示する
    local function selectionCount()
      local mode = vim.fn.mode()
      local start_line, end_line, start_pos, end_pos

      -- 選択モードでない場合には無効
      if not (mode:find("[vV\22]") ~= nil) then return "" end
      start_line = vim.fn.line("v")
      end_line = vim.fn.line(".")

      if mode == 'V' then
        -- 行選択モードの場合は、各行全体をカウントする
        start_pos = 1
        end_pos = vim.fn.strlen(vim.fn.getline(end_line)) + 1
      else
        start_pos = vim.fn.col("v")
        end_pos = vim.fn.col(".")
      end

      local chars = 0
      for i = start_line, end_line do
        local line = vim.fn.getline(i)
        local line_len = vim.fn.strlen(line)
        local s_pos = (i == start_line) and start_pos or 1
        local e_pos = (i == end_line) and end_pos or line_len + 1
        chars = chars + vim.fn.strchars(line:sub(s_pos, e_pos))
      end

      local lines = math.abs(end_line - start_line) + 1
      return tostring(lines) .. " lines, " .. tostring(chars) .. " characters"
    end

    require('lualine').setup {
      options = {
        theme = bubbles_theme,
        component_separators = '|',
        active = function()
          return vim.bo.buftype == ''
        end,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          { 'filename', path = 0 },
        },
        lualine_c = {
          { 'diff' },
          { 'diagnostics' }
        },
        lualine_x = {
        },
        lualine_y = {
          { 'filetype' },
          { lsp_clients, color = { fg = colors.white, bg = colors.grey } },
          {
            function()
              local alias = require 'salesforce.org_manager':get_default_alias()
              if alias and alias ~= "" then
                return "%#SalesforceIcon#󰢎 %#StatusText# " .. alias
              end
              return ""
            end,
            icon = nil, -- アイコンは関数内で動的に設定
          },
          { branch_with_icon,   color = { fg = colors.white, bg = colors.grey } },
          { encoding_with_icon, color = { fg = colors.white, bg = colors.grey } },
          {
            'fileformat',
            icons_enabled = true,
            symbols = {
              unix = '%#fileFormatIcon# %#FileFormatText# LF',
              dos = '%#fileFormatIcon# %#FileFormatText# CRLF',
              mac = '%#fileFormatIcon# %#FileFormatText# CR',
            },
          },
          { battery_status, color = { fg = colors.white, bg = colors.grey } },
          { current_time,   color = { fg = colors.white, bg = colors.grey } },
          { 'copilot',
            symbols = {
              status = {
                icons = {
                  enabled = " ",
                  sleep = " ", -- auto-trigger disabled
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
            show_colors = true },
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
      tabline = {
        lualine_c = {
          {
            'filename',
            path = 1, -- 1: relative path
            color = { fg = colors.darkGrey },
          },
        },
        lualine_x = {
        },
        lualine_y = {
          { next_calendar_event },
          { selectionCount },
        },
      },
      extensions = {},
    }
  end
}
