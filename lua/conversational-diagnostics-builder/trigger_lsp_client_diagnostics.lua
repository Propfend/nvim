local function trigger_lsp_client_diagnostics()
    local current_buffer = vim.api.nvim_get_current_buf()
    local attached_clients = vim.lsp.get_clients {
        name = 'null-ls',
        bufnr = current_buffer,
    }
    local conversational_diagnostics_client = attached_clients[1]

    if not conversational_diagnostics_client then
        vim.notify('null-ls is not attached to the current buffer', vim.log.levels.ERROR)

        return
    end

    conversational_diagnostics_client:notify('textDocument/didChange', {
        textDocument = { uri = vim.uri_from_bufnr(current_buffer) },
        contentChanges = {},
    })
end

return trigger_lsp_client_diagnostics
