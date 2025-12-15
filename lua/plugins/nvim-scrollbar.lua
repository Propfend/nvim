return {
  {
    'petertriho/nvim-scrollbar',
    dependencies = {
      'kevinhwang91/nvim-hlslens',
    },
    lazy = false,
    config = function()
      require('scrollbar').setup {
        show = true,
        marks = {
          Cursor = {
            text = '░',
          },
        },
      }
      require('scrollbar.handlers.search').setup {}
    end,
  },
}
