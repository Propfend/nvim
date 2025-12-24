return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = true,
        always_show_folders = false,
        never_show = { '.git' },
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['n'] = 'open',
          ['k'] = 'prev_sibling',
          ['l'] = 'next_sibling',
        },
      },
    },
  },
}
