local function build_numbered_document(document_lines)
    local numbered_lines = {}

    for document_row, document_line in ipairs(document_lines) do
        table.insert(numbered_lines, string.format('%d: %s', document_row, document_line))
    end

    return table.concat(numbered_lines, '\n')
end

return build_numbered_document
