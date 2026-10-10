local diagnostics_prompt = require 'conversational-diagnostics-builder.build_diagnostics_prompt'
local build_document_content_string = require 'conversational-diagnostics-builder.build_document_content_string'
local diagnostics_structured_output_format = require 'conversational-diagnostics-builder.diagnostics_structured_output_format'

local function build_request_body(diagnostics_params)
    return vim.json.encode {
        stream = false,
        messages = {
            {
                role = 'user',
                content = diagnostics_prompt.build_diagnostics_prompt(
                    diagnostics_prompt.CONVERSATIONAL_DIAGNOSTICS_ASSISTANT_PROMPT,
                    vim.g.none_ls_diagnostics_user_prompt
                ),
            },
            { role = 'user', content = build_document_content_string(diagnostics_params.content) },
        },
        response_format = {
            type = 'json_schema',
            json_schema = {
                name = 'conversational_diagnostics',
                schema = diagnostics_structured_output_format,
            },
        },
    }
end

if describe then
    describe('build_request_body', function()
        local diagnostics_params = { content = { 'test' } }

        before_each(function()
            vim.g.none_ls_diagnostics_user_prompt = 'flag everything'
        end)

        it('does not stream, so the response arrives as a single choice', function()
            assert.is_false(vim.json.decode(build_request_body(diagnostics_params)).stream)
        end)

        it('sends the prompt first and the document second', function()
            local messages = vim.json.decode(build_request_body(diagnostics_params)).messages

            assert.equals(2, #messages)
            assert.equals('test\n', messages[2].content)
        end)

        it('sends both messages with the user role', function()
            local messages = vim.json.decode(build_request_body(diagnostics_params)).messages

            assert.equals('user', messages[1].role)
            assert.equals('user', messages[2].role)
        end)

        it('puts the user prompt into the first message', function()
            local messages = vim.json.decode(build_request_body(diagnostics_params)).messages

            assert.truthy(messages[1].content:find('flag everything', 1, true))
        end)

        it('requests the diagnostics schema as structured output', function()
            local response_format = vim.json.decode(build_request_body(diagnostics_params)).response_format

            assert.equals('json_schema', response_format.type)
            assert.equals('conversational_diagnostics', response_format.json_schema.name)
        end)
    end)
end

return build_request_body
