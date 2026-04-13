return {
  {
    'petertriho/nvim-scrollbar',
    dependencies = {
      'kevinhwang91/nvim-hlslens',
    },
    lazy = false,
    config = function()
      require('scrollbar').setup {
        show = true,
        set_highlights = true,
        handle = {
          highlight = 'CursorColumn',
        },
        marks = {
          Cursor = {
            text = '░',
          },
          WordHighlight = {
            text = { '▎' },
            priority = 5,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = 'LocalHighlight',
          },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true,
          handle = true,
          search = true,
          ale = false,
        },
      }
      require('scrollbar.handlers.search').setup {}

      local word_handler_name = 'word_highlight'
      local word_pattern = nil

      require('scrollbar.handlers').register(word_handler_name, function(bufnr)
        if not word_pattern or word_pattern == '' then
          return {}
        end

        local marks = {}
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local escaped = vim.fn.escape(word_pattern, [[\.*$^~[]])
        local regex = vim.regex([[\V\<]] .. escaped .. [[\>]])

        for line_index, line_text in ipairs(lines) do
          if regex:match_str(line_text) then
            table.insert(marks, {
              line = line_index - 1,
              text = '▎',
              type = 'WordHighlight',
              level = 1,
            })
          end
        end

        return marks
      end)

      local function refresh_scrollbar()
        require('scrollbar.handlers').show()
        require('scrollbar').render()
      end

      local function update_word_marks()
        if vim.bo.buftype ~= '' then
          return
        end

        local word = vim.fn.expand '<cword>'
        local is_valid = word ~= '' and word:match '^[%w_]+$' and #word >= 2

        if not is_valid then
          if word_pattern ~= nil then
            word_pattern = nil
            refresh_scrollbar()
          end

          return
        end

        if word ~= word_pattern then
          word_pattern = word
          refresh_scrollbar()
        end
      end

      local group = vim.api.nvim_create_augroup('ScrollbarWordHighlight', { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = group,
        callback = update_word_marks,
      })
      vim.api.nvim_create_autocmd('BufLeave', {
        group = group,
        callback = function()
          word_pattern = nil
        end,
      })
    end,
  },
}
