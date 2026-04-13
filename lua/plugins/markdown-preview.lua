return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_port = '8040'
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_browser = '/run/current-system/sw/bin/google-chrome-stable'
      vim.g.mkdp_echo_preview_url = 0
    end,
    ft = { 'markdown' },
  },
}
