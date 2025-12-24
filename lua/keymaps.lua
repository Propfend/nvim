vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('i', '<Tab>', '<C-y>')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set({ 'n', 'v', 'i' }, 'f,', '<Cmd>BufferPrevious<CR>', { desc = 'Switch to previous window' })
vim.keymap.set({ 'n', 'v', 'i' }, 'f.', '<Cmd>BufferNext<CR>', { desc = 'Switch to next window' })

vim.keymap.set({ 'n', 'v' }, 'j', '<Left>')
vim.keymap.set({ 'n', 'v' }, 'k', '<Up>')
vim.keymap.set({ 'n', 'v' }, 'l', '<Down>')
vim.keymap.set({ 'n', 'v' }, 'ç', '<Right>')

vim.keymap.set('n', '<leader>k', function()
  require('treesitter-context').go_to_context(vim.v.count1)
end, { silent = true })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { silent = true })

vim.keymap.set('n', 'h', '<Nop>')

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
