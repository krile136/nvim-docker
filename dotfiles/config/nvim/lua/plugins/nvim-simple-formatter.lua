return {
  "krile136/nvim-simple-formatter",
  dependencies = {},
  config = function()
    require('nvim-simple-formatter').setup({
      format_rules = {
        {
          pattern = { "*.php" },
          command = "~/.local/share/nvim/mason/packages/phpcbf/phpcbf --standard=PSR2"
        }
      }
    })
  end
}
