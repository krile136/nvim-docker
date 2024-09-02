
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    -- 補完機能でメソッドとかにluanipを使うもの（メソッド名に引数が表示されてるやつ）は
    -- snippetの使用を優先する
    local snippetExtensions = { 'apex', 'cls' }

    -- アイコンの設定
    local kind_icons = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "",
      Variable = "",
      Class = "",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "C",
      Struct = "",
      Event = "",
      Operator = "",
      TypeParameter = "",
      Copilot = ""
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- Luasnipの設定
        end,
      },
      window = {
         completion = cmp.config.window.bordered(),
         documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            local entry = cmp.get_selected_entry()
            if entry and entry.source.name == 'nvim_lsp' then
              -- LSPソースの場合、メソッド名の後ろに()を追加
              local completion_item = entry:get_completion_item()
              local kind = completion_item.kind
              if kind == 2 or kind == 3 then  -- 2: Method, 3: Function
                cmp.confirm({ select = true })

                -- ファイルの拡張子がsnippetを補完に使用するか確認
                local currentExtension = vim.fn.expand('%:e')
                local isSnippetExtension = false
                for _, ext in ipairs(snippetExtensions) do
                  if ext == currentExtension then
                    isSnippetExtension = true
                    break
                  end
                end

                -- 拡張子が snippetExtensions に存在しない場合に処理を行う
                -- ()を後ろにつけて、そのカッコの中にカーソルを自動遷移
                if not isSnippetExtension then
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("()<Left>", true, true, true), "n", true)
                end
              else
                cmp.confirm({ select = true })
              end
            else
              cmp.confirm({ select = true })
            end
          else
            fallback()
          end
        end),
      }),
      formatting = {
        format = function(entry, vim_item)
          -- 関数の場合、括弧を追加する
          if vim.tbl_contains({'Function', 'Method'}, vim_item.kind) then
            vim_item.abbr = vim_item.abbr .. '()'
          end

          -- アイコンを追加
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)

          -- Source
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            buffer = "[Buffer]",
            path = "[Path]",
            nvim_lua = "[Lua]",
            copilot = "[Copilot]"
          })[entry.source.name]

          return vim_item
        end,
      },
      sources = cmp.config.sources({
        { name = "copilot", group = 'all'},
        { name = 'nvim_lsp', group = 'all'},
        { name = 'luasnip', group = 'all' },
        { name = 'nvim_lua', group = 'all'},
        { name = 'buffer', group = 'all' },
        { name = 'path', group = 'all' },
      })
    })

    -- copilotの色設定
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})
  end
}
