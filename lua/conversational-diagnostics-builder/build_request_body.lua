local build_diagnostics_prompt = require 'conversational-diagnostics-builder.build_diagnostics_prompt'
local build_numbered_document = require 'conversational-diagnostics-builder.build_numbered_document'

local CONVERSATIONAL_DIAGNOSTICS_STRUCTURED_OUTPUT_FORMAT = {
    type = 'object',
    properties = {
        diagnostics = {
            type = 'array',
            items = {
                type = 'object',
                properties = {
                    row = { type = 'integer', minimum = 1 },
                    col = { type = 'integer', minimum = 1 },
                    end_row = { type = 'integer', minimum = 1 },
                    end_col = { type = 'integer', minimum = 1 },
                    message = { type = 'string' },
                    severity = { type = 'integer', enum = { 1, 2, 3, 4 } },
                },
                required = { 'row', 'col', 'end_row', 'end_col', 'message', 'severity' },
                additionalProperties = false,
            },
        },
    },
    required = { 'diagnostics' },
    additionalProperties = false,
}

local function build_request_body(diagnostics_params)
    return vim.json.encode {
        stream = false,
        messages = {
            { role = 'user', content = build_diagnostics_prompt() },
            { role = 'user', content = build_numbered_document(diagnostics_params.content) },
        },
        response_format = {
            type = 'json_schema',
            json_schema = {
                name = 'conversational_diagnostics',
                schema = CONVERSATIONAL_DIAGNOSTICS_STRUCTURED_OUTPUT_FORMAT,
            },
        },
    }
end

return build_request_body
