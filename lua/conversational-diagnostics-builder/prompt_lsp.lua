local trigger_lsp_client_diagnostics = require 'conversational-diagnostics-builder.trigger_lsp_client_diagnostics'

vim.g.none_ls_diagnostics_user_prompt = nil

local function PromptLSP(user_prompt)
    vim.g.none_ls_diagnostics_user_prompt = user_prompt.args
    trigger_lsp_client_diagnostics()
end

if describe then
    describe('PromptLSP', function()
        before_each(function()
            vim.g.none_ls_diagnostics_user_prompt = nil
            vim.lsp.get_clients = function()
                return {}
            end
            vim.notify = function() end
        end)

        it('stores the command arguments as the user prompt', function()
            PromptLSP { args = 'flag every pronoun' }

            assert.equals('flag every pronoun', vim.g.none_ls_diagnostics_user_prompt)
        end)

        it('replaces a prompt left over from an earlier invocation', function()
            PromptLSP { args = 'first prompt' }
            PromptLSP { args = 'second prompt' }

            assert.equals('second prompt', vim.g.none_ls_diagnostics_user_prompt)
        end)

        it('stores an empty argument string as an empty prompt', function()
            PromptLSP { args = '' }

            assert.equals('', vim.g.none_ls_diagnostics_user_prompt)
        end)
    end)
end

return PromptLSP
