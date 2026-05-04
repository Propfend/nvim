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
    enable_diagnostics = true,
    sources = { 'filesystem' },
    default_component_configs = {
      diagnostics = {
        highlights = {
          hint = 'DiagnosticSignHint',
          info = 'DiagnosticSignInfo',
          warn = 'DiagnosticSignWarn',
          error = 'DiagnosticSignError',
        },
      },
    },
    event_handlers = {
      {
        event = 'vim_diagnostic_changed',
        handler = function()
          require('neo-tree.sources.manager').refresh 'filesystem'
        end,
      },
    },
    filesystem = {
      renderers = {
        file = {
          { 'indent' },
          { 'icon' },
          { 'diagnostics' },
          { 'name', use_git_status_colors = true },
          { 'git_status', highlight = 'NeoTreeDimText' },
        },
        directory = {
          { 'indent' },
          { 'icon' },
          { 'diagnostics', errors_only = true },
          { 'name' },
          { 'git_status', highlight = 'NeoTreeDimText' },
        },
      },
      follow_current_file = { enabled = true },
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
  config = function(_, opts)
    require('neo-tree').setup(opts)

    vim.api.nvim_create_autocmd('DiagnosticChanged', {
      callback = function()
        vim.schedule(function()
          if package.loaded['neo-tree'] then
            require('neo-tree.sources.manager').refresh 'filesystem'
          end
        end)
      end,
    })
  end,
}
