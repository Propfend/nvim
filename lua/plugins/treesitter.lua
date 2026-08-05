local ensure_installed = {
  'bash',
  'c',
  'css',
  'diff',
  'go',
  'html',
  'javascript',
  'lua',
  'luadoc',
  'markdown',
  'python',
  'query',
  'rust',
  'terraform',
  'vim',
  'vimdoc',
}

local function start_treesitter(buffer, language)
  vim.treesitter.start(buffer, language)
  vim.bo[buffer].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

local function start_treesitter_when_valid(buffer, language)
  if not vim.api.nvim_buf_is_valid(buffer) then
    return
  end

  start_treesitter(buffer, language)
end

local function is_installable(language)
  return vim.tbl_contains(require('nvim-treesitter').get_available(), language)
end

local function install_then_start_treesitter(buffer, language)
  require('nvim-treesitter').install(language):await(function()
    vim.schedule(function()
      start_treesitter_when_valid(buffer, language)
    end)
  end)
end

local function attach_treesitter(buffer, filetype)
  local language = vim.treesitter.language.get_lang(filetype)
  if not language then
    return
  end

  if vim.treesitter.language.add(language) then
    start_treesitter(buffer, language)

    return
  end

  if not is_installable(language) then
    return
  end

  install_then_start_treesitter(buffer, language)
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',

    config = function()
      require('nvim-treesitter').install(ensure_installed)

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          attach_treesitter(args.buf, args.match)
        end,
      })
    end,
  },
}
