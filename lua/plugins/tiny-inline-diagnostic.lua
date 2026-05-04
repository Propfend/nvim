return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'VeryLazy',
  priority = 1000,
  config = function()
    require('tiny-inline-diagnostic').setup({
      set_arrow_to_diag_color = false,
      options = {
        show_all_diags_on_cursorline = true,
        enable_on_insert = true,
        enable_on_select = true,
        multilines = {
          enabled = true,
          always_show = true,
        },
      },
    })
    vim.diagnostic.config { virtual_text = false }
  end,
}
