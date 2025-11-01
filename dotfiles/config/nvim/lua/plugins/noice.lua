return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      messages = {
        enabled = true,
      },
      notify = {
        enabled = true,
      },
      lsp = {
        progress = { enabled = true },
        messages = { enabled = true },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "written$",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "emsg", -- エラーメッセージ(emsg)に限定
            find = "E5108: Error executing lua.*lualine%.nvim.*Invalid window id",    -- noiceとlualineの組み合わせで、たまに出るけど問題ないエラーを無視
          },
          opts = { skip = true },
        },
      },
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
}
