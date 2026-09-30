local deserialize_request_body = require 'conversational-diagnostics-builder.deserialize_request_body'

local function parse_inference_response(serialized_diagnostics_response)
    local deserialized_diagnostics_response, deserialized_diagnostics_response_error = deserialize_request_body(serialized_diagnostics_response)

    if not deserialized_diagnostics_response then
        return nil, 'inference server returned invalid json: ' .. deserialized_diagnostics_response_error
    end

    local deserialized_diagnostics_response_first_choice = deserialized_diagnostics_response.choices and deserialized_diagnostics_response.choices[1]

    if
        not deserialized_diagnostics_response_first_choice
        or not deserialized_diagnostics_response_first_choice.message
        or not deserialized_diagnostics_response_first_choice.message.content
    then
        return nil, 'inference server response is missing choices[1].message.content'
    end

    local deserialized_diagnostics_response_structured_output, deserialized_diagnostics_response_structured_output_error =
        deserialize_request_body(deserialized_diagnostics_response_first_choice.message.content)

    if not deserialized_diagnostics_response_structured_output then
        return nil, 'response could not be deserialized: ' .. deserialized_diagnostics_response_structured_output_error
    end

    if type(deserialized_diagnostics_response_structured_output.diagnostics) ~= 'table' then
        return nil, 'structured output is missing a diagnostics array'
    end

    vim.print(deserialized_diagnostics_response_structured_output)

    return deserialized_diagnostics_response_structured_output.diagnostics, nil
end

return parse_inference_response
