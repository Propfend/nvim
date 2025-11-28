vim.o.number = true

vim.o.relativenumber = true

vim.o.autoindent = false

vim.opt.shiftwidth = 4

vim.opt.expandtab = true

vim.opt.tabstop = 4

vim.o.mouse = 'a'

vim.o.showmode = false

vim.o.background = 'dark'

vim.opt.whichwrap:append '<,>,h,l,[,]'

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
