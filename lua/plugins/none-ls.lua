return {
    'nvimtools/none-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = 'PromptLSP',
    config = function()
        local null_ls = require 'null-ls'
        local conversational_diagnostics_builder = require 'conversational-diagnostics-builder'

        null_ls.setup {
            sources = { conversational_diagnostics_builder.conversational_diagnostics_builder },
        }

        conversational_diagnostics_builder.create_user_command()
    end,
}
