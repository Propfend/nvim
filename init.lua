vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

require 'options'

require 'keymaps'

require 'lazy-bootstrap'

require 'lazy-plugins'

-- place this in one of your configuration file(s)
local hop = require 'hop'
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true }
end, { remap = true })
vim.keymap.set('', 'F', function()
  hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true }
end, { remap = true })
vim.keymap.set('', 't', function()
  hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }
end, { remap = true })
vim.keymap.set('', 'T', function()
  hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }
end, { remap = true })

require('image').setup {
  backend = 'kitty', -- or "ueberzug" or "sixel"
  processor = 'magick_cli', -- or "magick_rock"
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      only_render_image_at_cursor_mode = 'popup', -- or "inline"
      floating_windows = false, -- if true, images will be rendered in floating markdown windows
      filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
    },
    asciidoc = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      only_render_image_at_cursor_mode = 'popup',
      floating_windows = false,
      filetypes = { 'asciidoc', 'adoc' },
    },
    neorg = {
      enabled = true,
      filetypes = { 'norg' },
    },
    rst = {
      enabled = true,
    },
    typst = {
      enabled = true,
      filetypes = { 'typst' },
    },
    html = {
      enabled = false,
    },
    css = {
      enabled = false,
    },
  },
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,
  scale_factor = 1.0,
  window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
  window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', 'snacks_notif', 'scrollview', 'scrollview_sign' },
  editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
  tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' }, -- render image files as images when opened
}

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
