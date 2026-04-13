vim.o.number = true

vim.o.relativenumber = true

vim.o.autoindent = false

vim.opt.shiftwidth = 4

vim.opt.expandtab = true

vim.g.lazyvim_eslint_auto_format = true

vim.opt.tabstop = 4

vim.o.mouse = 'a'

vim.o.showmode = false

vim.o.background = 'dark'

vim.opt.whichwrap:append '<,>,h,l,[,]'

vim.g.clipboard = {
  name = 'wl-clipboard',
  copy = {
    ['+'] = 'wl-copy',
    ['*'] = 'wl-copy --primary',
  },
  paste = {
    ['+'] = 'wl-paste --no-newline',
    ['*'] = 'wl-paste --no-newline --primary',
  },
  cache_enabled = 0,
}

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true

vim.o.undofile = true
vim.o.mouse = 'a'

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'

vim.o.cursorline = true

vim.o.scrolloff = 0

vim.o.confirm = true

vim.o.autoread = true

local checktime_timer = vim.uv.new_timer()
checktime_timer:start(
  1000,
  1000,
  vim.schedule_wrap(function()
    if vim.fn.mode() ~= 'c' and vim.api.nvim_get_mode().blocking == false then
      vim.cmd.checktime()
    end
  end)
)

vim.api.nvim_create_autocmd('FileChangedShellPost', {
  desc = 'Notify when a buffer is reloaded from disk',
  group = vim.api.nvim_create_augroup('auto-checktime-notify', { clear = true }),
  callback = function()
    vim.notify('File changed on disk. Buffer reloaded.', vim.log.levels.INFO)
  end,
})
