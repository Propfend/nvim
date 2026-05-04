require('lazy').setup({
  'NMAC427/guess-indent.nvim',

  require 'plugins.gitsigns',

  require 'plugins.tiny-inline-diagnostic',

  require 'plugins.copilot-chat',

  require 'plugins.surround',

  require 'plugins.git-conflict',

  require 'plugins.nvim-fugitive',

  require 'plugins.markdown-preview',

  require 'plugins.hop',

  require 'plugins.gitsigns',

  require 'plugins.rhai',

  require 'plugins.image',

  require 'plugins.telescope',

  require 'plugins.copilot',

  require 'plugins.lspconfig',

  require 'plugins.conform',

  require 'plugins.gruvbox',

  require 'plugins.tokyonight',

  require 'plugins.local-highlight',

  require 'plugins.arduino-nvim',

  require 'plugins.nvim-scrollbar',

  require 'plugins.nvim-web-devicons',

  require 'plugins.nvim-barbar',

  require 'plugins.snacks',

  require 'plugins.blink-cmp',

  require 'plugins.treesitter-context',

  -- require 'plugins.mini',

  require 'plugins.treesitter',

  require 'plugins.indent-line',

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
