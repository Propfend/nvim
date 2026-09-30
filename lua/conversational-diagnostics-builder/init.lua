local null_ls = require 'null-ls'
local PromptLSP = require 'conversational-diagnostics-builder.prompt_lsp'
local request_diagnostics_from_inference_server = require 'conversational-diagnostics-builder.request_diagnostics_from_inference_server'

local M = {}

M.conversational_diagnostics_builder = {
    name = 'conversational_diagnostics_builder',
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = { 'markdown', 'text' },
    generator = {
        async = true,
        fn = request_diagnostics_from_inference_server,
    },
}

M.create_user_command = function()
    vim.api.nvim_create_user_command('PromptLSP', PromptLSP, { nargs = 1 })
end

return M
