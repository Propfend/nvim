return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',

    opts = {
      ensure_installed = { 
        'bash', 
        'c', 
        'css',
        'diff', 
        'html', 
        'lua', 
        'luadoc', 
        'markdown', 
        'query', 
        'javascript',
        'rust',
        'terraform',
        'go',
        'vim', 
        'python',
        'vimdoc'
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = true },
    },
  },
}
