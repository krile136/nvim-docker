return {
  "lukas-reineke/indent-blankline.nvim",
  event = 'VimEnter', -- Neovimの起動が完了した後にロード
  main = "ibl",
  opts = {},
  config = function()
    local highlight = {
      "LightBlue",
    }
    local hooks = require "ibl.hooks"
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "LightBlue", { fg = "#ADD8E6" })
    end)

    vim.g.rainbow_delimiters = { highlight = highlight }
    require("ibl").setup {
      scope = { highlight = highlight },
      indent = { char = "▏" }
    }

    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end
}
