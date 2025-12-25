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

local events = { 'BufEnter', 'BufWritePost', 'CursorMoved' }

local my_group = vim.api.nvim_create_augroup('NvimListeners', { clear = true })

vim.api.nvim_create_autocmd(events, {
    group = my_group,
    pattern = { '*' },
    callback = function(args)
        print('Event fired in file: ' .. args.file)
    end,
})

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
