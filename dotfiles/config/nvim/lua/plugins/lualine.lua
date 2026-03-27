_G.vim = vim

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


    -- 現在日付をアイコンと一緒に表示する
    local function current_date()
      return "%#DateIcon# %#StatusText# " .. os.date("%m/%d(%a)")
    end

    -- 現在のSalesforce組織のエイリアスを表示する
    local function showCurrentSalesforceOrg()
      local alias = require 'salesforce.org_manager':get_default_alias()
      if alias and alias ~= "" then
        return "%#SalesforceIcon#󰢎 %#SalesforceOrgDefault# " .. alias
      end
      return ""
    end

    -- パスのパンくずリスト表示
    -- nvim-web-devicons が読み込まれているか確認
    local devicons_ok, devicons = pcall(require, 'nvim-web-devicons')
    local file_icon = " " -- (U+F15C)
    local dir_icon = "%#LualineDirIcon# "
    local root_icon = ""
    local lualine_hl_cache = {
      last_original_hl = nil, -- 最後に適用した devicon の HL グループ名
    }

    -- LualineBreadcrumbFileIcon の 'guifg' を動的に変更するヘルパー
    local function get_dynamic_devicon(filename, default_icon_str)
      local base_hl = "LualineBreadcrumbText" -- ファイル名用のHL

      -- string.match を使い、末尾が .cls, .cmp, .triggerかどうかをチェック
      if filename:match("%.cls$") or filename:match("%.cmp$") or filename:match("%.trigger$") then
        local sf_icon = "󰢎 " -- Salesforce icon + space
        local sf_hl = "LualineBreadcrumbSalesforceIcon"

        -- LualineBreadcrumbFileIcon を更新する必要はない（使っていない）ため
        -- キャッシュには触らず、専用のハイライトで返す
        return string.format("%%#%s#%s%%#%s#%s", sf_hl, sf_icon, base_hl, filename)
      end
      if not devicons_ok then
        -- devicon がなければ固定アイコン
        return string.format("%%#%s#%s%s", base_hl, default_icon_str, filename)
      end

      local icon, original_hl_name = devicons.get_icon(filename)

      if not icon then
        icon = default_icon_str -- 強制的にデフォルトアイコンをセット
        original_hl_name = nil  -- ハイライトもリセット
      else
        icon = icon .. " "      -- 見つかった場合のみスペースを追加
      end

      if not original_hl_name then
        if lualine_hl_cache.last_original_hl ~= "FALLBACK_TO_BASE" then
          pcall(vim.api.nvim_set_hl, 0, "LualineBreadcrumbFileIcon", { link = base_hl })
          lualine_hl_cache.last_original_hl = "FALLBACK_TO_BASE"
        end
        return string.format("%%#LualineBreadcrumbFileIcon#%s%%#%s#%s", default_icon_str, base_hl, filename)
      end

      -- 最後に適用したHL (例: DevIconLua) と違っていたら、
      -- LualineBreadcrumbFileIcon の色を更新
      if original_hl_name ~= lualine_hl_cache.last_original_hl then
        -- 1. 元のHL (DevIconLua) から 'guifg' を取得
        local ok, hl_info = pcall(vim.api.nvim_get_hl_by_name, original_hl_name, true)
        local fg_color = (ok and hl_info.foreground) or nil

        if fg_color then
          -- 2. 'guifg' だけ抽出し、'guibg' は #080808 でHLを上書き
          pcall(vim.api.nvim_set_hl, 0, "LualineBreadcrumbFileIcon", {
            fg = fg_color,
            bg = colors.black -- '#080808'
          })
        else
          -- 3. 元のHLから 'guifg' が取れなかった場合 (フォールバック)
          pcall(vim.api.nvim_set_hl, 0, "LualineBreadcrumbFileIcon", {
            link = base_hl -- LualineBreadcrumbText にリンク
          })
        end

        -- 4. 適用したHL (DevIconLua) をキャッシュに保存
        lualine_hl_cache.last_original_hl = original_hl_name
      end

      -- 5. 動的に色が変わるHLをアイコンに、ベースHLをファイル名に適用
      return string.format("%%#LualineBreadcrumbFileIcon#%s%%#%s#%s", icon, base_hl, filename)
    end

    local function breadcrumbs()
      local is_oil_buffer = (vim.bo.filetype == 'oil')
      local path_source = vim.fn.expand('%')
      local rel_path

      if is_oil_buffer then
        -- 1. oilバッファの場合 (例: oil:///Users/foo/bar)
        path_source = path_source:gsub("^oil://", "")
        rel_path = vim.fn.fnamemodify(path_source, ':.')
      else
        -- 2. 通常のファイルバッファ
        rel_path = vim.fn.fnamemodify(path_source, ':.')
      end

      -- ルート、[No Name]、または CWD のファイル を処理
      if rel_path == '' or rel_path == '.' then
        -- 1. oil でルートを開いている場合 (最優先)
        if is_oil_buffer then
          -- このケースでは "ROOT" のみを表示して即時リターンする
          return string.format("%%#LualineRootIcon#%s %%#LualineBreadcrumbText#ROOT", root_icon)
        end

        -- 2. [No Name] バッファ
        local filename_only = vim.fn.expand('%:t')
        if filename_only == '' then
          return "%#Comment# [No Name] " -- [No Name] バッファ
        end

        -- 3. CWD にあるファイル (e.g. README.md)
        -- ヘルパー関数を呼び出し、下のロジックに流す
        return get_dynamic_devicon(filename_only, file_icon)
      end

      local parts = {}

      if rel_path ~= '.' and rel_path ~= '' then
        for part in string.gmatch(rel_path, "([^/]+)") do
          table.insert(parts, part)
        end
      else
        -- CWD のファイル (上記 3. のケース)
        local filename_only = vim.fn.expand('%:t')
        if filename_only ~= '' then
          table.insert(parts, filename_only)
        end
      end

      local components = {}

      -- 常に "ROOT" から始める
      local root_str = string.format("%%#LualineRootIcon#%s %%#LualineBreadcrumbText#ROOT", root_icon)
      table.insert(components, root_str)

      if #parts == 0 then
        return table.concat(components) -- "ROOT" のみ返す
      end

      -- 区切り文字 (› (U+203A) を使用)
      local separator = "%#LualineBreadcrumbSeparator# › "

      -- oil バッファかどうかで、最後の要素をどう扱うか分岐
      local loop_end = #parts
      if not is_oil_buffer then
        loop_end = #parts - 1 -- 通常ファイルなら、最後はファイル名として別処理
      end

      if loop_end < 0 then loop_end = 0 end

      -- ディレクトリ部分
      for i = 1, loop_end do
        local part = parts[i]
        table.insert(components, dir_icon .. "%#LualineBreadcrumbText#" .. part)
      end

      -- ファイル名部分 (通常ファイルバッファの場合のみ実行)
      if not is_oil_buffer then
        if #parts > 0 then
          local filename = parts[#parts]
          local file_str = get_dynamic_devicon(filename, file_icon)
          table.insert(components, file_str)
        end
      end

      -- 全てのコンポーネントを区切り文字で連結
      return table.concat(components, separator)
    end

    -- 現在のファイル名（とアイコン）だけを表示する関数
    -- -----------------------------------------------------------
    local function current_file_with_icon()
      local is_oil_buffer = (vim.bo.filetype == 'oil')
      local filename_only = vim.fn.expand('%:t')

      -- oil でサブディレクトリを開いている or [No Name] バッファの場合は空文字を返す
      if is_oil_buffer or filename_only == '' then
        return ''
      end

      -- 通常のファイル
      return get_dynamic_devicon(filename_only, file_icon)
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
        local file, _ = io.open("/root/calendar_lualine.txt", "r")
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
            cached_calendar_event = string.format("%s | %s | %s", next_event.title, next_event.time,
              next_event.place)
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
      tabline = {
        lualine_a = {
        },
        lualine_b = {
          { showCurrentSalesforceOrg },
        },
        lualine_c = {
          { breadcrumbs },
        },
        lualine_x = {
          -- { next_calendar_event },
          { selectionCount },
        },
        lualine_y = {
        },
        lualine_z = {
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
        },
        lualine_c = {
          { current_file_with_icon }
        },
        lualine_x = {
          { 'diagnostics' },
          { 'diff' },
        },
        lualine_y = {
          { 'filetype' },
          { lsp_clients,        color = { fg = colors.white, bg = colors.grey } },
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
          { current_date,   color = { fg = colors.white, bg = colors.grey } },
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
      extensions = {},
    }
  end
}
