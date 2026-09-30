local trigger_lsp_client_diagnostics = require 'conversational-diagnostics-builder.trigger_lsp_client_diagnostics'

vim.g.none_ls_diagnostics_user_prompt = nil

function PromptLSP(user_prompt)
    vim.g.none_ls_diagnostics_user_prompt = user_prompt.args
    trigger_lsp_client_diagnostics()
end

return PromptLSP
