vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

require 'options'

require 'keymaps'

require 'lazy-bootstrap'

require 'lazy-plugins'

vim.cmd [[colorscheme gruvbox]]

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

local function compile_and_upload_arduino_sketch()
  vim.cmd 'w'
  vim.cmd 'InoCheck'
  vim.cmd 'InoUpload'
end

vim.keymap.set('n', '<leader>a', compile_and_upload_arduino_sketch, {
  noremap = true,
  silent = true,
  desc = 'Save, compile and upload arduino sketch',
})

vim.cmd [[let g:terraform_fmt_on_save=1]]
vim.cmd [[let g:terraform_align=1]]
-- local events = { 'BufEnter', 'BufWritePost', 'CursorMoved' }
--
-- local my_group = vim.api.nvim_create_augroup('NvimListeners', { clear = true })
--
-- vim.api.nvim_create_autocmd(events, {
--     group = my_group,
--     pattern = { '*' },
--     callback = function(args)
--         print('Event fired in file: ' .. args.file)
--     end,
-- })

local function my_on_attach(bufnr)
  local api = require 'nvim-tree.api'

  vim.keymap.set('n', '<LeftRelease>', function()
    local api = require 'nvim-tree.api'
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      api.node.open.edit()
    end
  end, {})
end
