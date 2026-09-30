local function deserialize_request_body(serialized_request_body)
    local success, deserialized_request_body = pcall(vim.json.decode, serialized_request_body)

    if not success then
        return nil, deserialized_request_body
    end

    return deserialized_request_body, nil
end

return deserialize_request_body
