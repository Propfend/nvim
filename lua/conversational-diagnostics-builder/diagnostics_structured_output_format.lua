local DIAGNOSTICS_STRUCTURED_OUTPUT_FORMAT = {
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

return DIAGNOSTICS_STRUCTURED_OUTPUT_FORMAT
