local function parse_inference_response(serialized_diagnostics_response)
    local deserialized_response_success, deserialized_diagnostics_response = pcall(vim.json.decode, serialized_diagnostics_response)

    if not deserialized_response_success then
        return nil, 'inference server returned invalid json: ' .. deserialized_diagnostics_response
    end

    local deserialized_diagnostics_response_first_choice_content = deserialized_diagnostics_response.choices
        and deserialized_diagnostics_response.choices[1].message.content

    if not deserialized_diagnostics_response_first_choice_content then
        return nil, 'inference server response is missing choices[1].message.content'
    end

    local structured_output_success, deserialized_diagnostics_response_structured_output =
        pcall(vim.json.decode, deserialized_diagnostics_response_first_choice_content)

    if not structured_output_success then
        return nil, 'response could not be deserialized: ' .. deserialized_diagnostics_response_structured_output
    end

    if type(deserialized_diagnostics_response_structured_output.diagnostics) ~= 'table' then
        return nil, 'structured output is missing a diagnostics array'
    end

    return deserialized_diagnostics_response_structured_output.diagnostics, nil
end

if describe then
    describe('parse_inference_response', function()
        local function inference_response(content)
            return vim.json.encode { choices = { { message = { content = content } } } }
        end

        it('returns the diagnostics array from the structured output', function()
            local diagnostics = parse_inference_response(inference_response '{"diagnostics":[{"row":1}]}')

            assert.equals(1, #diagnostics)
            assert.equals(1, diagnostics[1].row)
        end)

        it('returns an empty array when the model reports no diagnostics', function()
            assert.equals(0, #parse_inference_response(inference_response '{"diagnostics":[]}'))
        end)

        it('reports invalid json from the inference server', function()
            local diagnostics, parse_error = parse_inference_response 'not json'

            assert.is_nil(diagnostics)
            assert.truthy(parse_error:find('inference server returned invalid json', 1, true))
        end)

        it('reports a response without choices', function()
            local diagnostics, parse_error = parse_inference_response(vim.json.encode { object = 'error' })

            assert.is_nil(diagnostics)
            assert.truthy(parse_error:find('missing choices[1].message.content', 1, true))
        end)

        it('reports structured output that is not json', function()
            local diagnostics, parse_error = parse_inference_response(inference_response '```json\n{}\n```')

            assert.is_nil(diagnostics)
            assert.truthy(parse_error:find('response could not be deserialized', 1, true))
        end)

        it('reports structured output without a diagnostics array', function()
            local diagnostics, parse_error = parse_inference_response(inference_response '{"other":[]}')

            assert.is_nil(diagnostics)
            assert.truthy(parse_error:find('structured output is missing a diagnostics array', 1, true))
        end)
    end)
end

return parse_inference_response
