return {
  'karb94/neoscroll.nvim',
  config = function()
    require('neoscroll').setup()

    local t = {}
    t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '50' } }
    t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '50' } }
    require('neoscroll.config').set_mappings(t)
  end
}
