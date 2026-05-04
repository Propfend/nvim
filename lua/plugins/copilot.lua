return {
  {
    'github/copilot.vim',
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_enabled = true
      vim.g.copilot_filetypes = { ['*'] = true }
    end,
    config = function()
      vim.keymap.set('n', '<leader>cs', '<cmd>Copilot panel<CR>', { desc = 'Copilot: open suggestions panel' })
    end,
  },
}
