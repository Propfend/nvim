return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true, markdown = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt' },
        go = { 'gofmt' },
        python = { 'isort', 'black' },
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        nix = { 'alejandra' },
        terraform = { 'terraform_fmt' },
        markdown = {},
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
