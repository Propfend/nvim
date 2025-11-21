vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

require 'options'

require 'keymaps'

require 'lazy-bootstrap'

require 'lazy-plugins'

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
