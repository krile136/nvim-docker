return {
    "f-person/git-blame.nvim",
    -- load the plugin at startup
    event = "VeryLazy",
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin wil only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    opts = {
        -- your configuration comes here
        -- for example
        enabled = true,  -- if you want to enable the plugin
        message_template = "<author> | <date> | <summary>", -- template for the blame message, check the Message template section for more options
        date_format = "%Y/%m/%d %H:%M", -- template for the date, check Date format section for more options
        virtual_text_column = 1,  -- virtual text start column, check Start virtual text at column section for more options
    },
  config = function(_, opts)
    -- CursorLinexxx guibg=#222222 と背景色を合わせてある
    vim.cmd("highlight git-blame guifg=#696969 guibg=#222222")
    vim.g.gitblame_highlight_group = "git-blame"
    vim.g.gitblame_delay = 0

    -- Apply opts settings
    for k, v in pairs(opts) do
        vim.g["gitblame_" .. k] = v
    end

  end

}
