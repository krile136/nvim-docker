return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = {
    "zbirenbaum/copilot-cmp",
  },
  config = function()
    -- Escキーを送信するマッピングを作成(Copilotのリセット用)
    vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>', { noremap = true, silent = true })
    require("copilot").setup({
      panel = {
        enabled = false,    -- copilot-cmpを使うためpanelは使わない
        -- auto_refresh = false,
        -- keymap = {
        --   jump_prev = "[[",
        --   jump_next = "]]",
        --   accept = "<CR>",
        --   refresh = "gr",
        --   open = "<M-CR>"
        -- },
        -- layout = {
        --   position = "bottom", -- | top | left | right
        --   ratio = 0.4
        -- },
      },
      suggestion = {
        -- enabled = false,    -- copilot-cmpを使うためsuggestionは使わない
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<C-CR>",  -- Control + Enterに変更
          accept_word = false,
          accept_line = false,
          next = "<C-.>",
          prev = "<C-,>",
          -- dismiss = "<C-]>",
        },
      },
      -- filetypes = {
      --   yaml = false,
      --   markdown = false,
      --   help = false,
      --   gitcommit = false,
      --   gitrebase = false,
      --   hgcommit = false,
      --   svn = false,
      --   csv = false,
      --   ["."] = false,
      -- },
      -- copilot_node_command = 'node', -- Node.js version must be > 18.x
      -- server_opts_overrides = {},
    })
  end,

}
