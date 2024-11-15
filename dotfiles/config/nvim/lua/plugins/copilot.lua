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
        enabled = false, -- copilot-cmpを使うためpanelは使わない
      },
      suggestion = {
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<C-CR>", -- Control + Enterに変更
          accept_word = false,
          accept_line = false,
          next = "<C-.>",
          prev = "<C-,>",
        },
      },
    })
  end,
}
