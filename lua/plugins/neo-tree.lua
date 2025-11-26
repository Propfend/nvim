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
      window = {
        mappings = {
	  ["<leader>n"] = "open",
          ['\\'] = 'close_window',
	  ["n"] = 'open',
	  ["l"] = "next_sibling",
	  ["k"] = "prev_sibling",
        },
      },
    },
  },
}
