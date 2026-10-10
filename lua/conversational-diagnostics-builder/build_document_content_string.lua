local function build_document_content_string(document_lines)
    local document_lines_string = {}

    for _, document_line in ipairs(document_lines) do
        table.insert(document_lines_string, string.format('%s\n', document_line))
    end

    return table.concat(document_lines_string)
end

if describe then
    describe('build_document_content_string', function()
        it('terminates a single line with a newline', function()
            assert.equals('test\n', build_document_content_string { 'test' })
        end)

        it('joins several lines in order', function()
            assert.equals('one\ntwo\nthree\n', build_document_content_string { 'one', 'two', 'three' })
        end)

        it('returns an empty string for an empty document', function()
            assert.equals('', build_document_content_string {})
        end)

        it('preserves empty lines', function()
            assert.equals('one\n\ntwo\n', build_document_content_string { 'one', '', 'two' })
        end)

        it('preserves trailing whitespace inside a line', function()
            assert.equals('test \n', build_document_content_string { 'test ' })
        end)
    end)
end

return build_document_content_string
