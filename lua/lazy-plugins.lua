require('lazy').setup({
  'NMAC427/guess-indent.nvim',

  require 'plugins.gitsigns',

  require 'plugins.telescope',

  require 'plugins.copilot',

  require 'plugins.lspconfig',

  require 'plugins.conform',

  require 'plugins.gruvbox',

  require 'plugins.local-highlight',
  
  require 'plugins.blink-cmp',

  require 'plugins.mini',

  require 'plugins.treesitter',
  --
  require 'plugins.debug',
  require 'plugins.indent_line',
  require 'plugins.lint',
  require 'plugins.autopairs',
  require 'plugins.neo-tree',
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
