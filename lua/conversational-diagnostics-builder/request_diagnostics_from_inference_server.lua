local curl = require 'plenary.curl'
local build_request_body = require 'conversational-diagnostics-builder.build_request_body'
local parse_inference_response = require 'conversational-diagnostics-builder.parse_inference_response'

vim.g.none_ls_inference_server_address = 'http://127.0.0.1:8080'

local function request_diagnostics_from_inference_server(diagnostics_params, report_diagnostics)
    if not vim.g.none_ls_diagnostics_user_prompt then
        report_diagnostics()
        return
    end

    local request_body = build_request_body(diagnostics_params)

    local inference_server_address_completion_endpoint = vim.g.none_ls_inference_server_address .. '/v1/chat/completions'

    curl.post(inference_server_address_completion_endpoint, {
        headers = { content_type = 'application/json' },
        body = request_body,
        callback = function(diagnostics_response)
            if diagnostics_response.status ~= 200 then
                vim.schedule(function()
                    vim.notify(string.format('inference server responded with status %d', diagnostics_response.status), vim.log.levels.ERROR)
                end)
                report_diagnostics()
                return
            end

            local parsed_diagnostics, parse_error = parse_inference_response(diagnostics_response.body)

            if not parsed_diagnostics then
                vim.schedule(function()
                    vim.notify(parse_error, vim.log.levels.ERROR)
                end)
                report_diagnostics()
                return
            end

            report_diagnostics(parsed_diagnostics)
        end,
    })
end

return request_diagnostics_from_inference_server
