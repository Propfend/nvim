vim.api.nvim_set_hl(0, 'LocalHighlight', { bg = '#3b3f52', bold = true })

return {
  'tzachar/local-highlight.nvim',
  file_types = { 'lua', 'python', 'javascript', 'typescript', 'html', 'css', 'markdown', 'rust', 'terraform', 'c', 'cpp' },
  disable_file_types = { 'tex' },
  hlgroup = 'LocalHighlight',
  cw_hlgroup = 'LocalHighlight',
  insert_mode = true,
  min_match_len = 1,
  max_match_len = math.huge,
  highlight_single_match = true,
  animate = {
    enabled = true,
    easing = 'linear',
    duration = {
      step = 10, -- ms per step
      total = 100, -- maximum duration
    },
  },
  debounce_timeout = 200,
}
